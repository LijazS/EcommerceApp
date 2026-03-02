# Build stage: compile the war using Maven and cache dependencies
FROM maven:3.9.6-eclipse-temurin-17 AS builder
WORKDIR /app
COPY pom.xml ./
RUN mvn dependency:go-offline -B
COPY src ./src
RUN mvn clean package -DskipTests -B

# Run stage: lightweight Tomcat image
FROM tomcat:9.0-jdk17-temurin

# Remove default ROOT webapp so ours becomes the root context
RUN rm -rf /usr/local/tomcat/webapps/*

# copy the built war
COPY --from=builder /app/target/*.war /usr/local/tomcat/webapps/ROOT.war

# create a volume for writable data (sqlite file, logs, etc.)
VOLUME ["/data"]

EXPOSE 8080
WORKDIR /usr/local/tomcat
CMD ["catalina.sh", "run"]