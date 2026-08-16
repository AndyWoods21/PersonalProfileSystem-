package za.ac.bl;

import za.ac.org.PersonalInfoEntity;

/**
 * Local interface for PersonalInfoEntity facade.
 */
public interface PersonalInfoEntityFacadeLocal {
    
    void create(PersonalInfoEntity personalInfoEntity);
    
    void edit(PersonalInfoEntity personalInfoEntity);
    
    void remove(PersonalInfoEntity personalInfoEntity);
    
    PersonalInfoEntity find(Object id);
    
    PersonalInfoEntity findByUser(Object userId);
}
