package za.ac.org;

import javax.annotation.Generated;
import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;
import za.ac.org.User;

@Generated(value="EclipseLink-2.7.10.v20211216-rNA", date="2026-08-22T00:06:44")
@StaticMetamodel(PersonalInfoEntity.class)
public class PersonalInfoEntity_ { 

    public static volatile SingularAttribute<PersonalInfoEntity, String> githubUrl;
    public static volatile SingularAttribute<PersonalInfoEntity, String> linkedinUrl;
    public static volatile SingularAttribute<PersonalInfoEntity, String> avatarUrl;
    public static volatile SingularAttribute<PersonalInfoEntity, String> phone;
    public static volatile SingularAttribute<PersonalInfoEntity, String> websiteUrl;
    public static volatile SingularAttribute<PersonalInfoEntity, String> jobTitle;
    public static volatile SingularAttribute<PersonalInfoEntity, String> professionalSummary;
    public static volatile SingularAttribute<PersonalInfoEntity, String> location;
    public static volatile SingularAttribute<PersonalInfoEntity, Long> id;
    public static volatile SingularAttribute<PersonalInfoEntity, String> fullname;
    public static volatile SingularAttribute<PersonalInfoEntity, User> user;
    public static volatile SingularAttribute<PersonalInfoEntity, String> email;

}