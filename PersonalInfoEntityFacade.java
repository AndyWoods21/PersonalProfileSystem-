/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package za.ac.bl;

import javax.annotation.security.PermitAll;
import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.NoResultException;
import javax.persistence.PersistenceContext;
import za.ac.org.PersonalInfoEntity;
import za.ac.org.User;

/**
 *
 * @author user
 */
@Stateless
@PermitAll
public class PersonalInfoEntityFacade extends AbstractFacade<PersonalInfoEntity> implements PersonalInfoEntityFacadeLocal {

    @PersistenceContext(unitName = "PersonalProfileModulePU")
    private EntityManager em;

    @Override
    protected EntityManager getEntityManager() {
        return em;
    }

    public PersonalInfoEntityFacade() {
        super(PersonalInfoEntity.class);
    }

    @Override
    public PersonalInfoEntity findByUser(User user) {
        if (user == null || user.getId() == null) {
            return null;
        }
        try {
            return em.createQuery(
                    "SELECT p FROM PersonalInfoEntity p WHERE p.user.id = :userId", PersonalInfoEntity.class)
                    .setParameter("userId", user.getId())
                    .getSingleResult();
        } catch (NoResultException e) {
            return null; // Return null safely if no profile exists for the user yet
        }
    }

}