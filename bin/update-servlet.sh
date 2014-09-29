#!/usr/bin/env /bin/bash
#
# Use citeservlet to build new war file, and
# load it into tomcat.

SERVLET_CONF=/vagrant/configs/servletconf.gradle
SERVLET_LINKS=/vagrant/configs/servletlinks.gradle
OVERLAY=/dev/null

while getopts "o:l:c:" opt; do

    case $opt in
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
    echo "Usage: update-servlet.sh  [-c SERVLET_CONF_FILE] [-l SERVLET_LINKS_FILE] [-o CUSTOM_OVERLAY_DIRECTORY]"
    exit -1
fi

# Builds a war file for a CITE project. 
/vagrant/bin/build-war.sh -c $SERVLET_CONF -l $SERVLET_LINKS -o $OVERLAY

# Installs newly built war file in tomcat and reboots tomcat.
/vagrant/bin/run-war.sh



