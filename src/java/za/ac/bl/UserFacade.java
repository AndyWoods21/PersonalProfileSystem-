/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package za.ac.bl;

import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.NoResultException;
import javax.persistence.PersistenceContext;
import za.ac.org.User;

/**
 *
 * @author user
 */
@Stateless
public class UserFacade extends AbstractFacade<User> implements UserFacadeLocal {

    @PersistenceContext(unitName = "PersonalProfileModulePU")
    private EntityManager em;

    @Override
    protected EntityManager getEntityManager() {
        return em;
    }

    public UserFacade() {
        super(User.class);
    }

    @Override
    public User findByUsername(String username) {
        try {
            return em.createNamedQuery("User.findByUsername", User.class)
                    .setParameter("username", username)
                    .getSingleResult();
        } catch (NoResultException e) {
            return null; // Return null if user does not exist
        }
    }

    @Override
    public User findByVerificationToken(String token) {
        try {
            return em.createNamedQuery("User.findByVerificationToken", User.class)
                    .setParameter("verificationToken", token)
                    .getSingleResult();
        } catch (Exception e) {
            return null;
        }
    }
    
    @Override
    public User findByOtpCode(String otpCode) {
        try {
            return em.createQuery("SELECT u FROM User u WHERE u.otpCode = :otpCode", User.class)
                    .setParameter("otpCode", otpCode)
                    .getSingleResult();
        } catch (NoResultException e) {
            return null;
        }
    }
}
