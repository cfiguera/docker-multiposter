FROM referup/multiposter

MAINTAINER Carles Figuera <cfiguera@referup.com>


# TIMEZONE

ENV TZ Europe/Madrid
RUN rm /etc/localtime && \
    ln -s /usr/share/zoneinfo/$TZ /etc/localtime


# CURL

RUN apt-get update -y && apt-get upgrade -y && apt-get install -y curl


# JAVA
ENV JAVA_MINOR 72
ENV JAVA_BASE 15
RUN wget --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u$JAVA_MINOR-b$JAVA_BASE/server-jre-8u$JAVA_MINOR-linux-x64.tar.gz && \
    tar -zxf server-jre-8u$JAVA_MINOR-linux-x64.tar.gz -C /opt && \
    mv /opt/jdk1.8.0_$JAVA_MINOR /opt/jdk && \
    rm /usr/bin/java && \
    ln -s /opt/jdk/bin/java /usr/bin/java && \
    rm server-jre-8u$JAVA_MINOR-linux-x64.tar.gz


# CONFIG

ENV JAVA_HOME /opt/jdk
ENV JAVA_OPTS="-XX:+UseG1GC $JAVA_OPTS"

ENV M2_REPO /root/.m2/repository
ENV MAVEN_OPTS="-XX:+UseG1GC $MAVEN_OPTS"


# VOLUME

RUN mkdir /cloe
VOLUME /cloe
VOLUME /$M2_REPO


# ENTRYPOINT

ENTRYPOINT /multiposter-boot.sh && exec cloe_run $MP_ACTION

