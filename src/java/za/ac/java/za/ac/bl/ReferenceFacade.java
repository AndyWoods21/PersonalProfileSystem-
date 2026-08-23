/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package za.ac.bl;

import java.util.Collections;
import java.util.List;
import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import za.ac.org.Reference;
import za.ac.org.User;

/**
 *
 * @author user
 */
@Stateless
public class ReferenceFacade extends AbstractFacade<Reference> implements ReferenceFacadeLocal {

    @PersistenceContext(unitName = "PersonalProfileModulePU")
    private EntityManager em;

    @Override
    protected EntityManager getEntityManager() {
        return em;
    }

    public ReferenceFacade() {
        super(Reference.class);
    }

    @Override
    public List<Reference> findByUser(User user) {
        if (user == null || user.getId() == null) {
            return Collections.emptyList();
        }
        return em.createQuery("SELECT r FROM Reference r WHERE r.user.id = :userId", Reference.class)
                 .setParameter("userId", user.getId())
                 .getResultList();
    }
}