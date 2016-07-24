#!/bin/bash
#

CITESERVLET_DIR=/vagrant/repositories/citeservlet
CONF=/vagrant/configs/servletconf.gradle
LINKS=/vagrant/configs/servletlinks.gradle
OVERLAY=/dev/null

while getopts "s:c:l:o:" opt; do
    case $opt in 
	s)
	    CITESERVLET_DIR=$OPTARG
	    ;;

	c)
	    CONF=$OPTARG
	    ;;
	l)
	    LINKS=$OPTARG
	    ;;
	o)
	    OVERLAY=$OPTARG
	    ;;
    esac
done


shift $((OPTIND-1))

if [ $# -ne 0 ];  then
    echo "build-war.sh:  bad syntax."
    echo "Usage: build-war.sh [-s CITESERVLET_DIR] [-c SERVLET_CONF_FILE] [-l SERVLET_LINKS_FILE] [-o CUSTOM_OVERLAY_DIRECTORY]"
    exit -1
fi


echo "Using configuration files ${CONF} and ${LINKS}"
echo "Overlaying material from ${OVERLAY}"

GIT=`which git`
GRADLE=`which gradle`


cd $CITESERVLET_DIR
$GRADLE clean
$GRADLE -Pconf=$CONF -Plinks=$LINKS -Pcustom="${OVERLAY}" war


