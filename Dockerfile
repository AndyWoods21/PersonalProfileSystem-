# Stage 1: Build the WAR package using Maven & Java 21
FROM maven:3.9.6-eclipse-temurin-21 AS build
WORKDIR /app

# Copy pom.xml and source code directories
COPY pom.xml .
COPY src ./src
COPY web ./web

# Package application WAR artifact
RUN mvn clean package -DskipTests

# Stage 2: Deploy to Payara Application Server
FROM payara/server-full:latest

# Copy WAR file to a temporary location inside the container
COPY --from=build /app/target/PersonalProfileSystem-1.0-SNAPSHOT.war /opt/payara/app.war

# Create a post-boot script to undeploy default ROOT and deploy app as contextroot '/'
RUN echo "undeploy ROOT" > ${POST_BOOT_COMMANDS} && \
    echo "deploy --contextroot / /opt/payara/app.war" >> ${POST_BOOT_COMMANDS}

EXPOSE 8080
