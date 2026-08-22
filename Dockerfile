# Stage 1: Build the WAR file using Apache Ant & Java 21
FROM freeleaves/ant:latest AS build
WORKDIR /app

# Copy source code and build requirements
COPY build.xml .
COPY nbproject ./nbproject
COPY src ./src
COPY web ./web
COPY lib ./lib

# Execute Ant build task
RUN ant -f build.xml -Dlibs.CopyLibs.classpath=lib/org-netbeans-modules-java-j2ee-copylibs-manifest.jar

# Stage 2: Deploy to Payara (GlassFish-compatible Java EE Server)
FROM payara/server-full:latest
COPY --from=build /app/dist/PersonalProfileSystem.war $DEPLOY_DIR/

EXPOSE 8080
