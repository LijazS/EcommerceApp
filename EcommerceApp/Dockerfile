FROM maven:eclipse-temurin AS builder

WORKDIR /app

COPY pom.xml .
RUN mvn dependency:go-offline

COPY src ./src

RUN mvn clean package -DskipTests


FROM eclipse-temurin:17-jre-alpine

WORKDIR /app

COPY --from=builder /app/target/*.jar app.jjar

EXPOSE 8080

ENTRYPOINT ["java","-jar","app.jar"]