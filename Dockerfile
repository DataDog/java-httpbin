FROM eclipse-temurin:11-jdk-jammy as builder

RUN apt update && apt-get install maven wget -y

WORKDIR /app

RUN keytool -genkey -alias sitename -keyalg RSA -keystore keystore.jks -keysize 2048 -storepass 123456 -dname "CN=DD, OU=DD, O=DD, L=DD, S=DD, C=DD"

COPY pom.xml ./
COPY src/ ./src
RUN wget -O dd-java-agent.jar https://dtdg.co/latest-java-tracer

RUN mvn clean install

FROM eclipse-temurin:11-jdk-jammy

COPY --from=builder /app/target/httpbin-1.3.1-SNAPSHOT-jar-with-dependencies.jar httpbin.jar
COPY --from=builder /app/keystore.jks /keystore.jks
COPY --from=builder /app/dd-java-agent.jar /dd-java-agent.jar

CMD ["java", "-javaagent:/dd-java-agent.jar", "-jar", "httpbin.jar", "-keystore", "/keystore.jks" ]
