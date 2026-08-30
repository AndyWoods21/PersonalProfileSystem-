/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package za.ac.bl;

import java.util.List;
import javax.ejb.Local;
import za.ac.org.Certification;
import za.ac.org.User;

/**
 *
 * @author user
 */
@Local
public interface CertificationFacadeLocal {

    void create(Certification certification);

    void edit(Certification certification);

    void remove(Certification certification);

    Certification find(Object id);

    List<Certification> findAll();

    List<Certification> findRange(int[] range);

    int count();

    List<Certification> findByUser(User user);
}