#!/usr/bin/env /bin/bash
#
# Use citemgr to build new ttl file, and
# load it into fuseki.

MANAGER_CONF=/vagrant/configs/managerconf.gradle

while getopts "m:" opt; do

    case $opt in
	m)
	    echo Set configuration file to $OPTARG
	    MANAGER_CONF=$OPTARG
	    ;;
    esac
done
shift $((OPTIND-1))

if [ $# -ne 0 ];  then
    echo "Bad syntax."
    echo "Usage: update-ttl.sh [-m MANAGER_CONF_FILE]"
    exit -1
fi

/vagrant/bin/built-ttl.sh $MANAGER_CONF
/vagrant/bin/load-ttl.sh




