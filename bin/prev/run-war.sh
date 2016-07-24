#!/usr/bin/env /bin/bash
#
# install cite-servlet.war in tomcat and restart tc
#

WAR=/vagrant/repositories/citeservlet/build/libs/citeservlet-0.9.0.war

RM=`which rm`
CP=`which cp`

if [ ! -f $WAR ]; then
    echo "No war file built."
else 
    sudo service tomcat6 stop
    if [ -f  /var/lib/tomcat6/webapps/cite-servlet.war ]; then
	echo "Removing previous files"
	sudo $RM /var/lib/tomcat6/webapps/cite-servlet.war
	sudo $RM -rf /var/lib/tomcat6/webapps/cite-servlet
    fi
    echo "Installing new war: $WAR"
    sudo $CP $WAR /var/lib/tomcat6/webapps/cite-servlet.war
    sudo service tomcat6 start
fi
