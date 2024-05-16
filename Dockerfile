FROM ubuntu:23.04

ENV JAVA_HOME=/u01/middleware/openjdk-11.0.0.1
ENV TOMCAT_HOME=/u01/middleware/apache-tomcat-9.0.89
ENV PATH=$PATH:$JAVA_HOME/bin:$TOMCAT_HOME/bin

RUN mkdir -p /u01/middleware
WORKDIR /u01/middleware

ADD https://download.java.net/openjdk/jdk11.0.0.1/ri/openjdk-11.0.0.1_linux-x64_bin.tar.gz .
RUN tar -xvzf openjdk-11.0.0.1_linux-x64_bin.tar.gz
RUN rm openjdk-11.0.0.1_linux-x64_bin.tar.gz

ADD https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.89/bin/apache-tomcat-9.0.89.tar.gz .
RUN tar -xvzf apache-tomcat-9.0.89.tar.gz
RUN rm apache-tomcat-9.0.89.tar.gz

COPY target/sailor.war $TOMCAT_HOME/webapps
COPY run.sh /tmp
RUN chmod u+x /tmp/run.sh
ENTRYPOINT [ "/tmp/run.sh" ]