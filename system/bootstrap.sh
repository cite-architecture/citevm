#!/usr/bin/env bash

#
# Add repository for an early-21st-century version of gradle:
add-apt-repository ppa:cwchien/gradle
apt-get update


#########################################################
### Install packages required for HMT editing ###########
#########################################################

# Clean up any catastrophic reformatting that
# 'git clone' could introduce on a Windows box:
apt-get install -y dos2unix
/usr/bin/dos2unix /vagrant/system/*sh
/usr/bin/dos2unix /vagrant/system/dotprofile
/usr/bin/dos2unix /vagrant/bin/*sh


# version control
apt-get install -y git

# JDK bundle
apt-get install -y openjdk-7-jdk
apt-get -y install groovy
apt-get -y install gradle


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


#########################################################
### Configure system and user settings        ###########
#########################################################

# System settings: default to US Eastern time for seminar:
#timedatectl set-timezone America/New_York

# Set up vagrant user account:
cp /vagrant/system/dotprofile /home/vagrant/.profile
chown vagrant:vagrant /home/vagrant/.profile


rm /home/vagrant/.config/plank/dock1/launchers/*.dockitem
cp /vagrant/system/plank-dock1-launchers/*.dockitem /home/vagrant/.config/plank/dock1/launchers
chown vagrant:vagrant /home/vagrant/.config/plank/dock1/launchers/*.dockitem
