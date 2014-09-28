#!/bin/bash


# instead of?  !/usr/bin/env /bin/bash
#
# Run through full CITE service build and boot sequence,
# using default settings for all configuration files.

# options:
# -m manager conf
# -c servlet conf
# -l servlet links
# -o custom overlay


echo "Setting default values before checking opts..."

MANAGER_CONF=/vagrant/configs/managerconf.gradle
SERVLET_CONF=/vagrant/configs/servletconf.gradle
SERVLET_LINKS=/vagrant/configs/servletlinks.gradle
OVERLAY=/dev/null

while getopts "m:c:l:o:" opt; do
    case $opt in 
	m)
	    echo Set manager configuration to $OPTARG
	    MANAGER_CONF=$OPTARG
	    ;;
	c)
	    echo Set servlet configuration to $OPTARG
	    SERVLET_CONF=$OPTARG
	    ;;
	l)
	    echo Set servlet links to $OPTARG
	    SERVLET_LINKS=$OPTARG
	    ;;
	o)
	    echo Set servlet overlay to $OPTARG
	    OVERLAY=$OPTARG
	    ;;
    esac
done





shift $((OPTIND-1))

if [ $# -ne 0 ];  then
    echo "Bad syntax."
    echo "Usage: boot-cite.sh [-m MANAGER_CONF_FILE] [-c SERVLET_CONF_FILE] [-l SERVLET_LINKS_FILE] [-o CUSTOM_OVERLAY_DIRECTORY]"
    exit -1
else 
    echo "All args parsed."
fi

# Builds RDF graph:
echo "Build TTL using configuration from ${MANAGER_CONF}"
/vagrant/bin/build-ttl.sh $MANAGER_CONF

# Loads the newly built RDF graph in fuseki using the configuration
# in /vagrant/system/fuseki-conf.ttl, and reboots fuseki.
/vagrant/bin/load-ttl.sh


# Builds a war file for a CITE project. 
/vagrant/bin/build-war.sh -c $SERVLET_CONF -l $SERVLET_LINKS -o $OVERLAY

# Installs newly built war file in tomcat and reboots tomcat.
/vagrant/bin/run-war.sh
