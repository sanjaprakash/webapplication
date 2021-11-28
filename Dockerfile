FROM sanjana141996/tomcat:v1
MAINTAINER sanjana
COPY target/java-tomcat-maven-example.war /usr/local/tomcat/webapps
