#!/usr/bin/env /bin/bash
#
# Run through full CITE service build and boot sequence,
# using default settings for all configuration files.

# options:
# -m manager conf
# -c servlet conf
# -l servlet links
# -o custom overlay


MANAGER_CONF=/vagrant/configs/managerconf.gradle
SERVLET_CONF=/vagrant/configs/servletconf.gradle
SERVLET_LINKS=/vagrant/configs/servletlinks.gradle
OVERLAY=/dev/null

while getopts "m:c:l:o:" opts; do
    case $opt in 
	m)
	    MANAGER_CONF=$OPTARG
	    ;;
	c)
	    SERVLET_CONF=$OPTARG
	    ;;
	l)
	    SERVLET_LINKS=$OPTARG
	    ;;
	o)
	    OVERLAY=$OPTARG
	    ;;
    esac
done


# Builds RDF graph using configuration in /vagrant/configs/managerconf.gradle. 
# To use a different configuration file:
#
# /vagrant/bin/build-ttl.sh FILENAME
/vagrant/bin/build-ttl.sh $MANAGER_CONF


# Loads the newly built RDF graph in fuseki using the configuration
# in /vagrant/system/fuseki-conf.ttl, and reboots fuseki.
/vagrant/bin/load-ttl.sh


# Builds a war file for a CITE project. 
/vagrant/bin/build-war.sh -c $SERVLET_CONF -l $SERVLET_LINKS -o $OVERLAY

# Installs newly built war file in tomcat and reboots tomcat.
/vagrant/bin/run-war.sh
