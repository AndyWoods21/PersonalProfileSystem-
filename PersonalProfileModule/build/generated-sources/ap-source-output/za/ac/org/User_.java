package za.ac.org;

import javax.annotation.Generated;
import javax.persistence.metamodel.ListAttribute;
import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;
import za.ac.org.Certification;
import za.ac.org.Education;
import za.ac.org.PersonalInfoEntity;
import za.ac.org.Reference;
import za.ac.org.Skill;
import za.ac.org.WorkExperience;

@Generated(value="EclipseLink-2.7.10.v20211216-rNA", date="2026-08-22T00:06:44")
@StaticMetamodel(User.class)
public class User_ { 

    public static volatile SingularAttribute<User, PersonalInfoEntity> personalInfo;
    public static volatile ListAttribute<User, Reference> referenceList;
    public static volatile SingularAttribute<User, String> role;
    public static volatile ListAttribute<User, Skill> skillList;
    public static volatile ListAttribute<User, Certification> certificationList;
    public static volatile ListAttribute<User, Education> educationList;
    public static volatile SingularAttribute<User, Long> id;
    public static volatile ListAttribute<User, WorkExperience> workExperienceList;
    public static volatile SingularAttribute<User, String> passwordHash;
    public static volatile SingularAttribute<User, String> username;

}