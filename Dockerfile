FROM quay.io/quarkus/ubi-quarkus-native-image:21.0.0-java11 as builder

WORKDIR /project
COPY . /project

RUN mvn package -Pnative -Dquarkus.native.container-build=true -Dquarkus.container-image.build=true

FROM registry.access.redhat.com/ubi8/ubi-minimal:8.4

WORKDIR /work/
COPY --from=builder /project/target/*-runner /work/application

CMD ./application -Dquarkus.http.host=0.0.0.0  -Dquarkus.http.port=${PORT}