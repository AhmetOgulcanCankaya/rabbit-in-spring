FROM amazoncorretto:17-alpine-full
VOLUME /tmp
EXPOSE 9091
ENV APP_PORT=9091
ARG JAR_FILE=target/rabbitmq-consumer-0.0.1-SNAPSHOT.jar
ADD ${JAR_FILE} app.jar
ENTRYPOINT ["java","-jar","/app.jar"]
