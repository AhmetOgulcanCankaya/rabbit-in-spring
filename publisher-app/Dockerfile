FROM amazoncorretto:17-alpine-full
VOLUME /tmp
EXPOSE 9090
ENV APP_PORT=9090
ARG JAR_FILE=target/rabbitmq-publisher-0.0.1-SNAPSHOT.jar
ADD ${JAR_FILE} app.jar
ENTRYPOINT ["java","-jar","/app.jar"]
