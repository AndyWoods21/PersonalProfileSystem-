# Stage 1: Build application package using Maven & Java 21
FROM maven:3.9.6-eclipse-temurin-21 AS build
WORKDIR /app

COPY pom.xml .
COPY src ./src
COPY web ./web

RUN mvn clean package -DskipTests

# Stage 2: Serve application using Payara Micro
FROM payara/micro:latest

# Copy WAR artifact directly to deployment directory
COPY --from=build /app/target/PersonalProfileSystem-1.0-SNAPSHOT.war /opt/payara/deployments/ROOT.war

ENV PORT=8080
EXPOSE 8080

ENTRYPOINT ["java", "-jar", "/opt/payara/payara-micro.jar"]
CMD ["--deploy", "/opt/payara/deployments/ROOT.war", "--port", "8080", "--contextroot", "/", "--nocluster", "--disablephonehome"]
