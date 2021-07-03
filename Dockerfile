FROM openjdk:11

ARG PROFILE
ARG ADDITIONAL_OPTIONS

ENV PROFILE=${PROFILE}
ENV ADDITIONAL_OPTIONS=${ADDITIONAL_OPTIONS}

WORKDIR /opt/spring_mysql_docker_sample

COPY /target/spring*.jar spring_mysql_docker_sample

SHELL ["/bin/sh", "-c"]

EXPOSE 5005
EXPOSE 8080

CMD java ${ADDITIONAL_OPTIONS} -jar spring_mysql_docker_sample --spring.profiles.active=${PROFILE}