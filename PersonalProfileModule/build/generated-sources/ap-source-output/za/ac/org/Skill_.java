package za.ac.org;

import javax.annotation.Generated;
import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;
import za.ac.org.User;

@Generated(value="EclipseLink-2.7.10.v20211216-rNA", date="2026-08-22T00:06:44")
@StaticMetamodel(Skill.class)
public class Skill_ { 

    public static volatile SingularAttribute<Skill, String> skillName;
    public static volatile SingularAttribute<Skill, String> proficiencyLevel;
    public static volatile SingularAttribute<Skill, Long> id;
    public static volatile SingularAttribute<Skill, String> category;
    public static volatile SingularAttribute<Skill, User> user;

}