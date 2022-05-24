FROM openjdk:11
EXPOSE 8081
COPY target/*.jar app.jar
CMD [ "java", "-jar", "app.jar" ]