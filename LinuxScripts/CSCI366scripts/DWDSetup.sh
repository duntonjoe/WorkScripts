#Author: 	Joe Dunton
#Desc:		This script automates configuration of turnkey lampstacks for CSCI366
#!/bin/bash

cd /etc/apt/sources.list.d/

#Upgrade to php7.0
cat << END >> sources.list
#PHP7.0:
deb http://packages.dotdeb.org jessie all
deb-src http://packages.dotdeb.org jessie all
END
apt-get update
wget https://www.dotweb.org/dotdeb.gpg
apt-key add dotdeb.gpg
apt-get install php7.0 php7.0-common php7.0-mysql

#finish apache configuration
cd /etc/apache2/mods-enabled
ln -s ../mods-available/php7.0.load
ln -s ../mods-available/php7.0.conf
rm php5.load
rm php5.conf
systemctl restart apache2
systemctl status apache2
