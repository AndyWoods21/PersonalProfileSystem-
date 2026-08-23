package za.ac.bl;

import java.util.List;
import javax.ejb.Local;
import za.ac.org.PersonalInfoEntity;
import za.ac.org.User;

/**
 * Local interface for PersonalInfoEntity stateless session bean facade.
 * 
 * @author user
 */
@Local
public interface PersonalInfoEntityFacadeLocal {

    void create(PersonalInfoEntity personalInfoEntity);

    void edit(PersonalInfoEntity personalInfoEntity);

    void remove(PersonalInfoEntity personalInfoEntity);

    PersonalInfoEntity find(Object id);

    List<PersonalInfoEntity> findAll();

    List<PersonalInfoEntity> findRange(int[] range);

    int count();

    // Query profile by User entity or User ID
    PersonalInfoEntity findByUser(User user);
    
}