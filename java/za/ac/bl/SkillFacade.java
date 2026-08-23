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
import za.ac.org.Skill;
import za.ac.org.User;

/**
 *
 * @author user
 */
@Stateless
public class SkillFacade extends AbstractFacade<Skill> implements SkillFacadeLocal {

    @PersistenceContext(unitName = "PersonalProfileModulePU")
    private EntityManager em;

    @Override
    protected EntityManager getEntityManager() {
        return em;
    }

    public SkillFacade() {
        super(Skill.class);
    }

    @Override
    public List<Skill> findByUser(User user) {
        if (user == null || user.getId() == null) {
            return Collections.emptyList();
        }
        return em.createQuery("SELECT s FROM Skill s WHERE s.user.id = :userId", Skill.class)
                 .setParameter("userId", user.getId())
                 .getResultList();
    }
}