#!/usr/bin/env bash

# Start from latest and greatest
apt-get update

# version control
apt-get install -y git
GIT=`which git`
echo Installed git at $GIT

# need to have the one true editor
# in case Neel Smith needs to work on
# the machine
apt-get install -y emacs

# and the other true editor
# in case Chris Blackwell needs to work on
# the machine
apt-get install -y vim

# for hosting on Windows
apt-get install -y dos2unix

# for variety of utilities
apt-get install -y sqlite

# Get full JDK *now* so we don't pull in
# jre as a dependency and have to
# add jdk later...


apt-get install -y openjdk-7-jdk

# build system and dependency mgt
apt-get install -y gradle
apt-get install -y maven

# Service suite:
apt-get install -y apache2
apt-get install -y libapache2-mod-fastcgi
apt-get install -y iipimage-server


# Mods to accommodate apache 2.4's default configuration
# settings:
if [ -d "/usr/share/iipimage-server" ]; then
    cp /usr/lib/iipimage-server/iipsrv.fcgi /usr/share/iipimage-server/iipsrv.fcgi
else 
    mkdir /usr/share/iipimage-server
    cp /usr/lib/iipimage-server/iipsrv.fcgi /usr/share/iipimage-server/iipsrv.fcgi
fi
cp /vagrant/system/iipsrv.conf  /etc/apache2/mods-available/iipsrv.conf
echo "Restarting apache with modified conifguration for iipsrv..."
service apache2 restart

apt-get install -y tomcat6


# Practical to have CLI browsing for local work:
apt-get install -y elinks



# Update and trust apt to clean up some space for us:
apt-get upgrade
apt-get -y autoremove

echo "Ran autoremove."


echo "Setting up account directory."
/bin/cp "/vagrant/system/dotprofile" "/home/vagrant/.profile"


# Set up proxying:
/bin/cp /vagrant/system/tc-server.xml /etc/tomcat6/server.xml 
/bin/cp /vagrant/system/000-default.conf-apache /etc/apache2/sites-available/000-default.conf

a2enmod  proxy
a2enmod proxy_http

service tomcat6 restart
service apache2 restart

