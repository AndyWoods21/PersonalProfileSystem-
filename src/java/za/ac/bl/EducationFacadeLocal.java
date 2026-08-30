/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package za.ac.bl;

import java.util.List;
import javax.ejb.Local;
import za.ac.org.Education;
import za.ac.org.User;

/**
 *
 * @author user
 */
@Local
public interface EducationFacadeLocal {

    void create(Education education);

    void edit(Education education);

    void remove(Education education);

    Education find(Object id);

    List<Education> findAll();

    List<Education> findRange(int[] range);

    int count();

    List<Education> findByUser(User user);
}