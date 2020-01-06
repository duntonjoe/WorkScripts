#Author: 	Joe Dunton
#Desc:		This script automates configuration of turnkey lampstacks for CSCI366
#!/bin/bash

echo $'\e[1;35m'Running system update...$'\e[0m'
#Update package mirrors and packages
apt-get update

echo $'\e[1;35m'Installing PostgreSQL...$'\e[0m'
#Hogg would like postgreSQL:
apt-get install postgresql-contrib
systemctl disable postgresql

echo $'\e[1;35m'Grabbing a JDK...$'\e[0m'
#Hogg would like tomcat (needs a JDK)
apt install default-jdk

echo $'\e[1;35m'Configuring tomcat group and user...$'\e[0m'
groupadd tomcat
useradd -s /bin/false -g tomcat -d /opt/tomcat tomcat
cd /tmp

echo $'\e[1;35m'Grabbing Tomcat Tar...$'\e[0m'
curl -O http://www-eu.apache.org/dist/tomcat/tomcat-9/v9.0.30/bin/apache-tomcat-9.0.30.tar.gz
mkdir /opt/tomcat 

echo $'\e[1;35m'Decompressing Tomcat...$'\e[0m'
tar -xf apache-tomcat-9.0.30.tar.gz
mv apache-tomcat-9.0.30/ /opt/tomcat
cd /opt/tomcat

echo $'\e[1;35m'Configuring Tomcat Permissions and Ownerships...$'\e[0m'
chgrp -R tomcat /opt/tomcat
chmod -R g+r /opt/tomcat/apache-tomcat-9.0.30/conf
chown -R tomcat apache-tomcat-9.0.30/*

echo $'\e[1;35m'Configuring JAVA_HOME, JRE_HOME, and CATALINA_HOME...$'\e[0m'
export CATALINA_HOME="/opt/tomcat/apache-tomcat-9.0.30/"
echo 'export CATALINA_HOME="/opt/tomcat/apache-tomcat-9.0.30/"' > /etc/profile.d/tomcat9.sh
export JAVA_HOME="/usr/lib/jvm/java-8-openjdk-amd64/"
echo 'export JAVA_HOME="/usr/lib/jvm/java-8-openjdk-amd64/"' >> /etc/profile.d/tomcat9.sh
export JRE_HOME="/usr/lib/jvm/java-8-openjdk-amd64/jre/"
echo 'export JRE_HOME="/usr/lib/jvm/java-8-openjdk-amd64/jre/"' >> /etc/profile.d/tomcat9.sh
source /etc/profile.d/tomcat9.sh

echo $'\e[1;35m'Making tomcat mgmt tools available remotely...$'\e[0m'
rm /opt/tomcat/apache-tomcat-9.0.30/webapps/manager/META-INF/context.xml && scp jmdunton@boole:/home/students/jmdunton/manager/context.xml /opt/tomcat/apache-tomcat-9.0.30/webapps/manager/META-INF/
rm /opt/tomcat/apache-tomcat-9.0.30/webapps/host-manager/META-INF/context.xml && scp jmdunton@boole:/home/students/jmdunton/host-manager/context.xml /opt/tomcat/apache-tomcat-9.0.30/webapps/manager/META-INF/

echo $'\e[1;35m'Make sure tomcat runs...$'\e[0m'
bash /opt/tomcat/apache-tomcat-9.0.30/bin/startup.sh && ping localhost -c 5 > /dev/null && bash /opt/tomcat/apache-tomcat-9.0.30/bin/shutdown.sh 

echo $'\e[1;35m'Checking Apache...$'\e[0m'
systemctl restart apache2
systemctl status apache2
