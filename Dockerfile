FROM ubuntu:23.04

ENV JAVA_HOME=/u01/middleware/jdk-11.0.22
ENV TOMCAT_HOME=/u01/middleware/apache-tomcat-9.0.89
ENV PATH=$PATH:${JAVA_HOME}/bin:${TOMCAT_HOME}/bin

RUN mkdir -p /u01/middleware
WORKDIR /u01/middleware

ADD https://download.oracle.com/otn/java/jdk/11.0.22%2B9/8662aac2120442c2a89b1ee9c67d7069/jdk-11.0.22_linux-x64_bin.tar.gz .
RUN tar -xvzf jdk-11.0.22_linux-x64_bin.tar.gz
RUN rm jdk-11.0.22_linux-x64_bin.tar.gz

ADD https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.89/bin/apache-tomcat-9.0.89.tar.gz .
RUN tar -xvzf apache-tomcat-9.0.89.tar.gz
RUN rm apache-tomcat-9.0.89.tar.gz

COPY target/sailor.war ${TOMCAT_HOME}/webapps
COPY run.sh /tmp
RUN chmod u+x /tmp/run.sh
ENTRYPOINT [ "/tmp/run.sh" ]