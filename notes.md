# [Construindo uma Api Rest com Spring Boot, Mysql, JPA Repostory e fazendo deploy na Docker](https://youtu.be/HR5Np1HmC7c)

### Configurações iniciais

* **Dockerfile**

    ```dockerfile
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
    ```
  
* **docker-compose**
  
    ```yml
    version: "3"
    
    services:
      spring_mysql_docker_sample:
        build:
          context: .
          dockerfile: ./Dockerfile
        image: spring_mysql_docker_sample/api
        ports:
        - "8080:8080"
        - "5005:5005"
        environment:
        - ADDITIONAL_OPTIONS=-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=*:5005 -Xmx1G -Xms128m -XX:MaxMetaspaceSize=128m
        - PROFILE=dev
        links:
        - mysql
    
      mysql:
        image: mysql:5.6
        ports:
          - "3306:3306"
        environment:
          - MYSQL_ROOT_HOST=%
          - MYSQL_DATABASE=spring_mysql_docker_sample
          - MYSQL_USER=root
          - MYSQL_ALLOW_EMPTY_PASSWORD=yes
        volumes:
          - ./.docker/mysql_data:/var/lib/mysql
    ```

* **application.yml**  

  ```yml
  spring:
    datasource:
      url: jdbc:mysql://mysql:3306/spring_mysql_docker_sample
      username: root
      password:
      name: SpringMysqlDockerSampleDataSource
      type: com.zaxxer.hikari.HikariDataSource # Definir o Connection Pool, ou seja, número de conexões abertas (https://www.devmedia.com.br/connection-pool/5869)
      driver-class-name: com.mysql.jdbc.Driver
  
      # Configurações do Connection Pool
      hikari:
        pool-name: SpringMysqlDockerSamplePool
        connection-test-query: select now() # Query para verificar se a conexão está ativa
        maximum-pool-size: 5
        minimum-idle: 1 # idle = conexão que não está em uso
        connection-timeout: 20000 # 20s
        idle-timeout: 10000 # 10s
  
    jpa:
      hibernate:
        ddl-auto: none # desabilitar a criação automática das tabelas a partir das entidades do modelo de domínio
  
      show-sql: true
      properties:
        hibernate:
          dialect: org.hibernate.dialect.MySQL5Dialect
  ```

### Inicialização do Projeto

* **Criação da Fat Jar e do Uber Jar**: `$ mvn clean install`

* **Criação dos container**: `$ docker-compose up --build --force-recreate`

### Database (utilização do recurso do Intellij Ultimate)

* **Ir até**: `Database` > `New (+)` > `Data Source` > `MySQL`

  * **User**: `root`
  * **Password**: 
  * **Database**: spring_mysql_docker_sample