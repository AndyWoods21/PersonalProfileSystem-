package za.ac.org;

import javax.annotation.Generated;
import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;
import za.ac.org.User;

@Generated(value="EclipseLink-2.7.10.v20211216-rNA", date="2026-08-22T00:06:44")
@StaticMetamodel(Certification.class)
public class Certification_ { 

    public static volatile SingularAttribute<Certification, String> credentialUrl;
    public static volatile SingularAttribute<Certification, Long> id;
    public static volatile SingularAttribute<Certification, String> title;
    public static volatile SingularAttribute<Certification, String> issueDate;
    public static volatile SingularAttribute<Certification, User> user;
    public static volatile SingularAttribute<Certification, String> issuingOrganization;

}