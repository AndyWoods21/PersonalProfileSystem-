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
import za.ac.org.Education;
import za.ac.org.User;

/**
 *
 * @author user
 */
@Stateless
public class EducationFacade extends AbstractFacade<Education> implements EducationFacadeLocal {

    @PersistenceContext(unitName = "PersonalProfileModulePU")
    private EntityManager em;

    @Override
    protected EntityManager getEntityManager() {
        return em;
    }

    public EducationFacade() {
        super(Education.class);
    }

    @Override
    public List<Education> findByUser(User user) {
        if (user == null || user.getId() == null) {
            return Collections.emptyList();
        }
        return em.createQuery("SELECT e FROM Education e WHERE e.user.id = :userId", Education.class)
                 .setParameter("userId", user.getId())
                 .getResultList();
    }
}