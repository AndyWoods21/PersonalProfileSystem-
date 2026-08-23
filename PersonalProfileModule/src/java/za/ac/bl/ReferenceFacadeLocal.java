/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package za.ac.bl;

import java.util.List;
import javax.ejb.Local;
import za.ac.org.Reference;
import za.ac.org.User;

/**
 *
 * @author user
 */
@Local
public interface ReferenceFacadeLocal {

    void create(Reference reference);

    void edit(Reference reference);

    void remove(Reference reference);

    Reference find(Object id);

    List<Reference> findAll();

    List<Reference> findRange(int[] range);

    int count();

    List<Reference> findByUser(User user);
}