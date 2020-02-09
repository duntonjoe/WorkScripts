#Author: 	Joe Dunton
#Desc:		This script automates configuration of turnkey lampstacks for CSCI366
#Notes:		This script depends on a couple things:
# 1) you must have the following prestaged files
#	/home/students/_USERNAME_/host-manager/context.xml
#	/home/students/_USERNAME_/manager/context.xml
#	/home/students/_USERNAME_/conf/context.xml
#	/home/students/_USERNAME_/conf/tomcat-users.xml
#		
#	 +---------------------------------------------------------+
#	 | the "_USERNAME_" needs to be replaced with the username |
#	 | of anybody running this script.                         |
#	 +---------------------------------------------------------+
#
#	The prestaged context files should be edited to allow
#	whatever locality is needed for the tomcat groups. For
#	our purposes, this locality will be configured to alllow
#	remote users with:
#
#	<Valve className="org.apache.catalina.valves.RemoteAddrValve" allow="127\.\d+\.\d+\.\d+|::1|0:0:0:0:0:0:0:1" />
#
#	tomcat-users.xml should have the following:
#	  -Any requested roles. These are the minimum required:
#	    <role rolename="manager-gui"/>
#	    <role rolename="admin-gui"/>
#	  -You should include a blank user to be filled in:
#
#	    <user username="XYZ" password="ZZYX" fullName="XYZ" roles="manager-gui,admin-gui"/>
#
#	  The username and password strings will be swapped
#	  out with real values within the script. If you 
#         wish to edit these for some reason, find the
#	  "Username/Password Configuration" comment.
#
# 2) you need curl, it's already installed in our enviornment


#!/bin/bash

echo $'\e[1;35m'Running system update...$'\e[0m'
#Update package mirrors and packages
apt-get update

read -p "Configure Hostname? (y/n): " choice
    case $choice in
        [Yy]* ) apt-get install dbus && read -p "enter hostanme: " host && hostnamectl set-hostname $host && reboot;;
        [Nn]* ) ;;
        * ) echo "Please answer yes or no.";;
    esac

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

echo $'\e[1;33m'Enter Username for remote user: $'\e[0m'
read remoteUser

echo $'\e[1;35m'Making tomcat mgmt tools available remotely...$'\e[0m'
rm /opt/tomcat/apache-tomcat-9.0.30/webapps/manager/META-INF/context.xml && scp $remoteUser@boole:/home/students/$remoteUser/manager/context.xml /opt/tomcat/apache-tomcat-9.0.30/webapps/manager/META-INF/
rm /opt/tomcat/apache-tomcat-9.0.30/webapps/host-manager/META-INF/context.xml && scp $remoteUser@boole:/home/students/$remoteUser/host-manager/context.xml /opt/tomcat/apache-tomcat-9.0.30/webapps/manager/META-INF/
rm /opt/tomcat/apache-tomcat-9.0.30/conf/context.xml && scp $remoteUser@boole:/home/students/$remoteUser/conf/context.xml /opt/tomcat/apache-tomcat-9.0.30/conf/

echo $'\e[1;35m'Make sure tomcat runs...$'\e[0m'
bash /opt/tomcat/apache-tomcat-9.0.30/bin/startup.sh && ping localhost -c 5 > /dev/null && bash /opt/tomcat/apache-tomcat-9.0.30/bin/shutdown.sh 

echo $'\e[1;35m'Configuring tomcat user$'\e[0m'
username=$(echo $HOSTNAME)
read -s -p $'\e[1;33m'"Enter password: "$'\e[0m' password
rm /opt/tomcat/apache-tomcat-9.0.30/conf/tomcat-users.xml
scp $remoteUser@boole:/home/students/$remoteUser/tomcat-users.xml  /opt/tomcat/apache-tomcat-9.0.30/conf/


#Username/Password configuration
sed -i "s/XYZ/$username/g" /opt/tomcat/apache-tomcat-9.0.30/conf/tomcat-users.xml
sed -i "s/ZZYX/$password/g" /opt/tomcat/apache-tomcat-9.0.30/conf/tomcat-users.xml
echo $'\e[1;33m'$username : $password $'\e[0m'

echo $'\e[1;35m'Allowing Remote MySQL access...$'\e[0m'
sed -i '/bind-address\t\t= 127.0.0.1/c\bind-address\t\t= 0.0.0.0'  /etc/mysql/mariadb.conf.d/50-server.cnf &&
	/etc/init.d/mysql restart


echo $'\e[1;35m'Checking Apache...$'\e[0m'
systemctl restart apache2
systemctl status apache2

history -c
