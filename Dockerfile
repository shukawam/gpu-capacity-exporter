FROM maven:3.9.5 as build
WORKDIR /helidon
ADD pom.xml pom.xml
RUN mvn package -Dmaven.test.skip -Declipselink.weave.skip -Declipselink.weave.skip -DskipOpenApiGenerate
ADD src src
RUN mvn package -DskipTests
RUN echo "done!"

FROM eclipse-temurin:21-jre
WORKDIR /helidon
COPY --from=build /helidon/target/instance-capacity-observer.jar ./
COPY --from=build /helidon/target/libs ./libs
CMD ["java", "-jar", "instance-capacity-observer.jar"]
EXPOSE 8080
