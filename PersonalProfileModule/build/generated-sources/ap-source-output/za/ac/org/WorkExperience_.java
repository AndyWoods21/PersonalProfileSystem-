package za.ac.org;

import javax.annotation.Generated;
import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;
import za.ac.org.User;

@Generated(value="EclipseLink-2.7.10.v20211216-rNA", date="2026-08-22T00:06:44")
@StaticMetamodel(WorkExperience.class)
public class WorkExperience_ { 

    public static volatile SingularAttribute<WorkExperience, String> endDate;
    public static volatile SingularAttribute<WorkExperience, String> companyName;
    public static volatile SingularAttribute<WorkExperience, String> jobTitle;
    public static volatile SingularAttribute<WorkExperience, String> description;
    public static volatile SingularAttribute<WorkExperience, Long> id;
    public static volatile SingularAttribute<WorkExperience, User> user;
    public static volatile SingularAttribute<WorkExperience, String> startDate;

}