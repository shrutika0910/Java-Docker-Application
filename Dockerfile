# Use a small Java runtime
FROM openjdk:17-jdk-slim

WORKDIR /app

# the jar produced by maven-shade: update filename if you change pom
ARG JAR_FILE=target/java-hello-1.0.0-jar-with-dependencies.jar
COPY ${JAR_FILE} /app/app.jar

EXPOSE 8080
ENV PORT=8080
# optional: include the build id in environment if you want (Jenkins will set BUILD env)
CMD ["java", "-jar", "/app/app.jar"]
