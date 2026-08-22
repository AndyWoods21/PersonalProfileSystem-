# Stage 1: Build the WAR file using Eclipse Temurin JDK 21 and Ant
FROM eclipse-temurin:21-jdk AS build

# Install Apache Ant
RUN apt-get update && apt-get install -y ant && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy source code and build files
COPY build.xml .
COPY nbproject ./nbproject
COPY src ./src
COPY web ./web
COPY lib ./lib

# Execute Ant build task
RUN ant -f build.xml -Dlibs.CopyLibs.classpath=lib/org-netbeans-modules-java-j2ee-copylibs-manifest.jar

# Stage 2: Deploy to Payara Application Server
FROM payara/server-full:latest
COPY --from=build /app/dist/PersonalProfileSystem.war $DEPLOY_DIR/

EXPOSE 8080
