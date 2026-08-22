# Stage 1: Build the WAR file using Eclipse Temurin JDK 21 and Ant
FROM eclipse-temurin:21-jdk AS build

# Install Apache Ant
RUN apt-get update && apt-get install -y ant && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy available project source files
COPY build.xml .
COPY src ./src
COPY web ./web

# Execute Ant build task ignoring missing NetBeans tasks
RUN ant -f build.xml -Dno.deps=true -Dlibs.CopyLibs.classpath=

# Stage 2: Deploy to Payara Application Server
FROM payara/server-full:latest
COPY --from=build /app/dist/*.war $DEPLOY_DIR/

EXPOSE 8080
