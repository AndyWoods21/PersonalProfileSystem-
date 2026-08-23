# Stage 1: Build application package using Maven & Java 8
FROM maven:3.8.8-eclipse-temurin-8 AS build
WORKDIR /app

COPY pom.xml .
COPY src ./src
COPY web ./web

RUN mvn clean package -DskipTests

# Stage 2: Serve application using Payara Micro 5
FROM payara/micro:5.2022.2

# Copy WAR artifact directly to deployment directory
COPY --from=build /app/target/PersonalProfileSystem-1.0-SNAPSHOT.war /opt/payara/deployments/ROOT.war

ENV PORT=8080
EXPOSE 8080

ENTRYPOINT ["java", "-jar", "/opt/payara/payara-micro.jar"]
CMD ["--deploy", "/opt/payara/deployments/ROOT.war", "--port", "8080", "--contextroot", "/", "--nocluster", "--disablephonehome"]
