# syntax=docker/dockerfile:1

FROM openjdk:16-alpine3.13

WORKDIR /app

COPY .mvn/ .mvn
COPY mvnw pom.xml ./
RUN ./mvnw dependency:go-offline

COPY src ./src
# CMD ["./mvnw","clean", "install"]

# CMD ["tail", "-f", "/dev/null" ]
CMD ["./mvnw", "spring-boot:run", "-Dspring-boot.run.profiles=mysql"]
