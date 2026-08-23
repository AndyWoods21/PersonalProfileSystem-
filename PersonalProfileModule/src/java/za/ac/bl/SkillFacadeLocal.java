/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package za.ac.bl;

import java.util.List;
import javax.ejb.Local;
import za.ac.org.Skill;
import za.ac.org.User;

/**
 *
 * @author user
 */
@Local
public interface SkillFacadeLocal {

    void create(Skill skill);

    void edit(Skill skill);

    void remove(Skill skill);

    Skill find(Object id);

    List<Skill> findAll();

    List<Skill> findRange(int[] range);

    int count();

    List<Skill> findByUser(User user);
}