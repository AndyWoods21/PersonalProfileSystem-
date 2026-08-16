package za.ac.org;

import java.io.Serializable;

/**
 * Entity class representing a user in the system.
 */
public class User implements Serializable {
    private static final long serialVersionUID = 1L;

    private Long userId;
    private String username;
    private String passwordHash;
    private String email;
    private String firstName;
    private String lastName;
    private String role;

    public User() {
    }

    public User(String username, String password, String email) {
        this.username = username;
        this.passwordHash = password;
        this.email = email;
    }

    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPasswordHash() {
        return passwordHash;
    }

    public void setPasswordHash(String passwordHash) {
        this.passwordHash = passwordHash;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public void setRole(String role) {
        this.role = role;
    }
    public String getRole() {
        return role;
    }
}
