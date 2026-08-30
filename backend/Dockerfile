FROM eclipse-temurin:17-jdk-alpine

WORKDIR /app

COPY pom.xml .

COPY maven/apache-maven-3.9.9 /opt/maven

ENV PATH="/opt/maven/bin:${PATH}"

COPY src ./src

RUN mvn clean package -DskipTests

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "target/samadhanx-backend-1.0.0-SNAPSHOT.jar"]
