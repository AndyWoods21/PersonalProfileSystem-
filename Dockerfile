# Stage 1: Build the WAR package using Maven & Java 21
FROM maven:3.9.6-eclipse-temurin-21 AS build
WORKDIR /app

# Copy pom.xml and source code directories
COPY pom.xml .
COPY src ./src
COPY web ./web

# Package application WAR artifact
RUN mvn clean package -DskipTests

# Stage 2: Deploy WAR file as ROOT application to Payara
FROM payara/server-full:latest
COPY --from=build /app/target/PersonalProfileSystem-1.0-SNAPSHOT.war $DEPLOY_DIR/ROOT.war

EXPOSE 8080
