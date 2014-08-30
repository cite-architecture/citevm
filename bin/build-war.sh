#!/usr/bin/env /bin/bash
#
# Build  cite-servlet. 


CONF=$1
LINKS=$2
OVERLAY=$3

if [ $# -eq 4 ]; then
    BRANCH=$4
else 
    BRANCH=master
fi


GIT=`which git`
GRADLE=`which gradle`

cd /vagrant/repositories/citeservlet
echo "Build war file.  Clean out previous build."

$GRADLE clean

echo "Build new war file from vm* configuration file ${CONF}, ${LINK} and ${OVERLAY}"

$GRADLE -Pconf=buildconfs/$CONF   -Plinks=buildconfs/$LINKS -Pcustom=$OVERLAY war



