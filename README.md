# PersonalProfileSystem

A Personal Profile System web application built with Java EE 7, Servlets, and EJB.

## Features

- **User Authentication**: Secure login system with password verification
- **User Registration**: Complete signup flow with profile confirmation
- **Personal Profile Management**: Add and edit personal information including job title, location, and professional summary
- **Public Profile Viewing**: View other users' public profiles
- **Session Management**: Secure session-based user tracking

## Technology Stack

- **Java**: 21 LTS (Upgraded from Java 8)
- **Build Tool**: Maven 3.10.0
- **Web Framework**: Java Servlet API 3.1.0
- **EJB**: Enterprise JavaBeans 3.2
- **Application Server**: GlassFish (via Java EE APIs)
- **Database**: Configured for EJB persistence

## Project Structure

```
src/
├── java/
│   └── za/ac/
│       ├── org/              # Entity models
│       │   ├── PersonalInfoEntity.java
│       │   └── User.java
│       ├── bl/               # Business Logic (Facade layer)
│       │   ├── PersonalInfoEntityFacadeLocal.java
│       │   └── UserFacadeLocal.java
│       └── Servlet/          # Web Controllers
│           ├── LoginServlet.java
│           ├── SignUpServlet.java
│           ├── ConfirmSignUp.java
│           ├── AddInformationServlet.java
│           └── PublicProfileServlet.java
└── test/                      # Unit tests

web/                           # JSP Views
├── login.jsp
├── signUp.jsp
├── Dashboard.jsp
├── AddInformation.jsp
├── publicProfile.jsp
└── index.html
```

## Build & Run

### Prerequisites
- Java 21 JDK
- Maven 3.10.0+

### Build

```bash
mvn clean package
```

This generates `target/PersonalProfileSystem-1.0-SNAPSHOT.war`

### Deploy

Deploy the WAR file to GlassFish or your preferred Java EE application server.

### Development

For local development:

```bash
mvn clean compile
mvn clean test
```

## Recent Upgrades

✅ **Java 8 → Java 21 LTS** (August 2026)
- Updated maven.compiler.source and maven.compiler.target to 21
- Upgraded maven-compiler-plugin from 3.8.1 to 3.11.0
- All tests passing (100% pass rate)
- No source code changes required (full API compatibility)
- No CVEs detected in dependencies

## Project Metadata

- **Group ID**: za.ac
- **Artifact ID**: PersonalProfileSystem
- **Version**: 1.0-SNAPSHOT
- **Packaging**: WAR (Web Application)

## License

[Add your license here]

## Contact

**Author**: Andile Buthelezi (AndyWoods21)  
**Repository**: [GitHub - PersonalProfileSystem](https://github.com/AndyWoods21/PersonalProfileSystem)
