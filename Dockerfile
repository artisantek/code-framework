FROM maven:3.6.3-openjdk-11 as build
WORKDIR /app
COPY . .
RUN mvn clean install

FROM openjdk:11-slim
WORKDIR /app
COPY scripts/startService.sh .
COPY --from=build /app/target/knote*.jar app.jar
CMD ["sh", "-c", "/app/startService.sh"]
