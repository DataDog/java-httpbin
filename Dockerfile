FROM eclipse-temurin:17-jdk-jammy as builder

WORKDIR /app

COPY pom.xml ./
COPY src/ ./src
RUN ls -lhR ./src
RUN ls -lhR ./
RUN apt update && apt-get install maven -y
RUN mvn clean install
RUN keytool -genkey -alias sitename -keyalg RSA -keystore keystore.jks -keysize 2048 -storepass 123456 -dname "CN=DD, OU=DD, O=DD, L=DD, S=DD, C=DD" 
 
FROM eclipse-temurin:17-jdk-jammy

COPY --from=builder /app/target/httpbin-1.3.1-SNAPSHOT-jar-with-dependencies.jar httpbin.jar
COPY --from=builder /app/keystore.jks /keystore.jks

CMD ["java", "-jar", "httpbin.jar", "-keystore", "/keystore.jks" ]
