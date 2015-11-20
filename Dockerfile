FROM referup/multiposter

MAINTAINER Carles Figuera <cfiguera@referup.com>


# TIMEZONE

ENV TZ Europe/Madrid
RUN rm /etc/localtime
RUN ln -s /usr/share/zoneinfo/$TZ /etc/localtime


# JAVA

RUN wget --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u66-b17/server-jre-8u66-linux-x64.tar.gz
RUN tar -zxf server-jre-8u66-linux-x64.tar.gz -C /opt
RUN mv /opt/jdk1.8.0_66 /opt/jdk
RUN rm server-jre-8u66-linux-x64.tar.gz
RUN rm /usr/bin/java
RUN ln -s /opt/jdk/bin/java /usr/bin/java


# CONF

ENV JAVA_HOME /opt/jdk
ENV M2_REPO /root/.m2/repository

ENV JAVA_OPTS="-XX:+UseG1GC $JAVA_OPTS"
ENV MAVEN_OPTS="-XX:+UseG1GC $MAVEN_OPTS"


# VOLUME

VOLUME /$M2_REPO


ENTRYPOINT /multiposter-boot.sh && exec cloe_run $MP_ACTION
