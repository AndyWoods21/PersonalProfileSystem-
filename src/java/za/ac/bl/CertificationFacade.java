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
import za.ac.org.Certification;
import za.ac.org.User;

/**
 *
 * @author user
 */
@Stateless
public class CertificationFacade extends AbstractFacade<Certification> implements CertificationFacadeLocal {

    @PersistenceContext(unitName = "PersonalProfileModulePU")
    private EntityManager em;

    @Override
    protected EntityManager getEntityManager() {
        return em;
    }

    public CertificationFacade() {
        super(Certification.class);
    }

    @Override
    public List<Certification> findByUser(User user) {
        if (user == null || user.getId() == null) {
            return Collections.emptyList();
        }
        return em.createQuery("SELECT c FROM Certification c WHERE c.user.id = :userId", Certification.class)
                 .setParameter("userId", user.getId())
                 .getResultList();
    }
}