package za.ac.bl;

import za.ac.org.User;

/**
 * Local interface for User entity facade.
 */
public interface UserFacadeLocal {
    
    void create(User user);
    
    void edit(User user);
    
    void remove(User user);
    
    User find(Object id);
    
    User findByUsername(String username);
    
    User findByEmail(String email);
}
