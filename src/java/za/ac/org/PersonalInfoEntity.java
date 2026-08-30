package za.ac.org;

import java.io.Serializable;
import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.OneToOne;
import javax.persistence.Table;

/**
 * Entity mapping personal profile information to the corresponding User entity.
 */
@Entity
@Table(name = "personal_info")
public class PersonalInfoEntity implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id") // Explicitly define database column name
    private Long id;

    @Column(name = "FullName")
    private String fullname;

    @Column(name = "JobTitle")
    private String jobTitle;

    @Column(name = "AvatarUrl")
    private String avatarUrl;

    @Column(name = "professionalSummary")
    private String professionalSummary;

    @Column(name = "email")
    private String email;

    // Changed Integer to String to support standard phone numbers
    @Column(name = "phone")
    private String phone;

    @Column(name = "location")
    private String location;

    @Column(name = "githubUrl")
    private String githubUrl;

    @Column(name = "linkedinUrl")
    private String linkedinUrl;

    @Column(name = "websiteUrl")
    private String websiteUrl;

    // Use MERGE cascade so referenced existing User is re-attached without triggering duplicate persists
    @OneToOne(cascade = {CascadeType.MERGE})
    @JoinColumn(name = "user_id", referencedColumnName = "id", nullable = true)
    private User user;

    public PersonalInfoEntity() {
    }

    public PersonalInfoEntity(String fullname, String jobTitle, String avatarUrl, String professionalSummary, String email, String phone, String location, String githubUrl, String linkedinUrl, String websiteUrl) {
        this.fullname = fullname;
        this.jobTitle = jobTitle;
        this.avatarUrl = avatarUrl;
        this.professionalSummary = professionalSummary;
        this.email = email;
        this.phone = phone;
        this.location = location;
        this.githubUrl = githubUrl;
        this.linkedinUrl = linkedinUrl;
        this.websiteUrl = websiteUrl;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public String getFullname() {
        return fullname;
    }

    public void setFullname(String fullname) {
        this.fullname = fullname;
    }

    public String getJobTitle() {
        return jobTitle;
    }

    public void setJobTitle(String jobTitle) {
        this.jobTitle = jobTitle;
    }

    public String getAvatarUrl() {
        return avatarUrl;
    }

    public void setAvatarUrl(String avatarUrl) {
        this.avatarUrl = avatarUrl;
    }

    public String getProfessionalSummary() {
        return professionalSummary;
    }

    public void setProfessionalSummary(String professionalSummary) {
        this.professionalSummary = professionalSummary;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public String getGithubUrl() {
        return githubUrl;
    }

    public void setGithubUrl(String githubUrl) {
        this.githubUrl = githubUrl;
    }

    public String getLinkedinUrl() {
        return linkedinUrl;
    }

    public void setLinkedinUrl(String linkedinUrl) {
        this.linkedinUrl = linkedinUrl;
    }

    public String getWebsiteUrl() {
        return websiteUrl;
    }

    public void setWebsiteUrl(String websiteUrl) {
        this.websiteUrl = websiteUrl;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (id != null ? id.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        if (!(object instanceof PersonalInfoEntity)) {
            return false;
        }
        PersonalInfoEntity other = (PersonalInfoEntity) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "za.ac.org.PersonalInfoEntity[ id=" + id + " ]";
    }
}
