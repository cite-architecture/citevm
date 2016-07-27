#!/usr/bin/env bash

#
# Add repository for an early-21st-century version of gradle:
add-apt-repository ppa:cwchien/gradle
apt-get update


# Clean up any catastrophic reformatting that
# 'git clone' could introduce on a Windows box:
apt-get install -y dos2unix
/usr/bin/dos2unix /vagrant/system/*sh
/usr/bin/dos2unix /vagrant/system/dotprofile
/usr/bin/dos2unix /vagrant/bin/*sh


# version control
apt-get install -y git

# JDK bundle.  Need Java 8 for fuseki, but
# elementary Freya/ubuntu 14.04 only has openjdk-7,
# so use oracle.

apt-get -y -q upgrade
apt-get -y -q install software-properties-common htop
add-apt-repository ppa:webupd8team/java
apt-get -y -q update
echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections
apt-get -y -q install oracle-java8-installer
update-java-alternatives -s java-8-oracle


apt-get -y install groovy
apt-get -y install gradle


# Service suite:
apt-get install -y apache2
apt-get install -y libapache2-mod-fastcgi
apt-get install -y iipimage-server

# configuration file with correct JAVA_HOME for our install:
cp /vagrant/system/etc-default-tomcat7 /etc/default/tomcat7

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


#########################################################
### Configure system and user settings        ###########
#########################################################

# System settings: default to US Eastern time for seminar:
#timedatectl set-timezone America/New_York

# Set up vagrant user account:
cp /vagrant/system/dotprofile /home/vagrant/.profile
chown vagrant:vagrant /home/vagrant/.profile

#
rm /home/vagrant/.config/plank/dock1/launchers/*.dockitem
cp /vagrant/system/plank-dock1-launchers/*.dockitem /home/vagrant/.config/plank/dock1/launchers
chown vagrant:vagrant /home/vagrant/.config/plank/dock1/launchers/*.dockitem


### SPARLQL END POINT #############################################
##


JENA_VERSION="apache-jena-3.1.0"
FUSEKI_VERSION="apache-jena-fuseki-2.4.0"


JENA_DIR="/opt/${JENA_VERSION}"
FUSEKI_DIR="/opt/${FUSEKI_VERSION}"

CURL=`which curl`
TAR=`which tar`
RM=`which rm`

# For tdbloader:
if [ -d $JENA_DIR ]; then
    echo "apache-jena already installed."
else
    echo  "Downloading apache-jena package..."
    $CURL http://apache.mirrors.pair.com/jena/binaries/${JENA_VERSION}.tar.gz  > /tmp/jena.tgz
    cd /opt
    sudo $TAR -zvxf /tmp/jena.tgz
    $RM /tmp/jena.tgz
fi

# For fuseki server:
if [ -d $FUSEKI_DIR ]; then
    echo "jena-fuseki already installed."
else
    echo "Downloading fuseki server..."
    $CURL http://apache.mirrors.pair.com/jena/binaries/${FUSEKI_VERSION}.tar.gz > /tmp/fuseki.tgz
    cd /opt
    sudo $TAR -zxvf /tmp/fuseki.tgz
    $RM /tmp/fuseki.tgz
fi



GIT=`which git`
echo git installed at $GIT

# This script is repsonsible for cloning or updating all HMT git repositories
# needed for editing.
#
# It's up to individual editors to maintain their own repository
# for editorial content.
#

if [ -d "/vagrant/cs2" ]; then
    echo "Checking for updates to cs2"
    cd /vagrant/cs2
    $GIT pull
else
    echo "Installing cs2"
    cd /vagrant
    echo  Running  $GIT clone
    https://github.com/cite-architecture/cs2.git
    $GIT clone https://github.com/cite-architecture/cs2.git
fi

if [ -d "/vagrant/cite-archive-manager" ]; then
    echo "Checking for updates to cite-archive-manager"
    cd /vagrant/cite-archive-manager
    $GIT pull
else
    echo "Installing cite-archive-manager"
    cd /vagrant
    echo  Running  $GIT clone     https://github.com/cite-architecture/cite-archive-manager.git
    $GIT clone https://github.com/cite-architecture/cite-archive-manager.git
fi


if [ -d "/vagrant/easy_cts_archive" ]; then
    echo "Checking for updates to easy_cts_archive"
    cd /vagrant/easy_cts_archive
    $GIT pull
    cp /vagrant/easy_cts_archive/manager-conf.gradle /vagrant/cite-archive-manager/conf.gradle
else
    echo "Installing easy_cts_archive"
    cd /vagrant
    echo  Running  $GIT clone
    https://github.com/cite-architecture/easy_cts_archive.git

    $GIT clone https://github.com/cite-architecture/easy_cts_archive.git
    cp /vagrant/easy_cts_archive/manager-conf.gradle /vagrant/cite-archive-manager/conf.gradle
fi


# 2. In /vagrant/cite-archive-manager, run gradle ctsttl
# 3. Run /vagrant/bin/load-ttl.sh script.


### CITE SERVLET  ##################################################
## BUILD DATA:
cp /vagrant/easy_cts_archive/manager-conf.gradle /vagrant/cite-archive-manager/conf.gradle

cd /vagrant/cite-archive-manager

GRADLE=`which gradle`
$GRADLE ctsttl
cp /vagrant/cite-archive-manager/build/ttl/cts.ttl /vagrant/data

/vagrant/bin/load-ttl.sh

# Need to compile cs2, and install in tomcat
cd /vagrant/cs2/sparqlcts
$GRADLE war
cp /vagrant/cs2/sparqlcts/build/lib/sparql\*.war /var/lib/tomcat/webapp/sparqlcts.war


### FURTHER CONFIGURATION  ##########################################
## - Consider proxying tc to apache, so exposing it to host machine easily
## - Install pretty web site from Chris' Krakow machine
## - Do we need /vagrant/configs?
