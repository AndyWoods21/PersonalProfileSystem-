package za.ac.org;

import javax.annotation.Generated;
import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;
import za.ac.org.User;

@Generated(value="EclipseLink-2.7.10.v20211216-rNA", date="2026-08-22T00:06:44")
@StaticMetamodel(Education.class)
public class Education_ { 

    public static volatile SingularAttribute<Education, String> endDate;
    public static volatile SingularAttribute<Education, String> institutionName;
    public static volatile SingularAttribute<Education, String> degree;
    public static volatile SingularAttribute<Education, Long> id;
    public static volatile SingularAttribute<Education, String> fieldOfStudy;
    public static volatile SingularAttribute<Education, User> user;
    public static volatile SingularAttribute<Education, String> startDate;

}