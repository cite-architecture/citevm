#!/usr/bin/env /bin/bash

GRADLE=`which gradle`
GIT=`which git`
MV=`which mv`


MANAGER_CONF=/vagrant/configs/managerconf.gradle

if [ "$#" -eq 1 ]; then
    MANAGER_CONF=$1
fi

$GRADLE clean
echo ""
echo "Building TTL using configuration file ${MANAGER_CONF}" 
$GRADLE -Pconf=$MANAGER_CONF ttl




