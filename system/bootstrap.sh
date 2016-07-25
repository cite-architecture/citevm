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


#apt-get install -y openjdk-7-jdk
apt-get -y -q update
apt-get -y -q upgrade
apt-get -y -q install software-properties-common htop
add-apt-repository ppa:webupd8team/java
apt-get -y -q update
echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections
echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections
apt-get -y -q install oracle-java8-installer
apt-get -y -q install oracle-java7-installer
update-java-alternatives -s java-8-oracle


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

apt-get install -y tomcat7


# Practical to have CLI browsing for local work:
apt-get install -y elinks



# Update and trust apt to clean up some space for us:
apt-get upgrade
apt-get -y autoremove

echo "Ran autoremove."


echo "Setting up account directory."
#/bin/cp "/vagrant/system/dotprofile" "/home/vagrant/.profile"


# Install config files from templates
#if [ ! -f "/vagrant/configs/managerconf.gradle" ]
#then
#    /bin/cp "/vagrant/configs/managerconf.gradle-template"
#fi
if [ ! -f "/vagrant/configs/servletconf.gradle" ]
then
    /bin/cp "/vagrant/configs/servletconf.gradle-template" "/vagrant/configs/servletconf.gradle"
fi
if [ ! -f "/vagrant/configs/servletlinks.gradle" ]
then
    /bin/cp "/vagrant/configs/servletlinks.gradle-template" "/vagrant/configs/servletlinks.gradle"
fi

# Set up proxying:
/bin/cp /vagrant/system/tc-server.xml /etc/tomcat7/server.xml
/bin/cp /vagrant/system/000-default.conf-apache /etc/apache2/sites-available/000-default.conf

a2enmod  proxy
a2enmod proxy_http

service tomcat7 restart
service apache2 restart

# Install basic CITE infrastructure:
#/vagrant/bin/refresh.sh
