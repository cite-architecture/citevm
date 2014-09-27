#!/usr/bin/env /bin/bash


# load and start fuseki via tdbloader2


# Use fresh build if available; otherwise, fall back on
# version checked out from VM repository.
if [ -e /vagrant/repositories/citemgr/build/rdf/all.ttl ]; then
    TTL=/vagrant/repositories/citemgr/build/rdf/all.ttl
else
    # Exit with error msg...
fi
echo "Load ttl from ${TTL}"
echo ""
echo""


# NB:  with shared directories extension in Vagrant,
# the TDB directory needs to be *outside* the shared
#  directory!

TDBDIR=/tmp/tdbs
CONF=/vagrant/system/fuseki-conf.ttl

JENA=/opt/jena-fuseki-1.1.0/fuseki-server
TDBLOADER=/opt/apache-jena-2.12.0/bin/tdbloader2
PORT=3030
export FUSEKI_HOME=/opt/jena-fuseki-1.1.0



# 1. Stop any running instance:
FUSER=`which fuser`
FUSEOUT=`$FUSER $PORT/tcp`
if [ -n "$FUSEOUT" ]; then
    echo "Killing previous running process ${FUSEOUT} ..."
    /bin/kill $FUSEOUT
fi

# 2. Blow out existing data dir:
echo Removing existing data from $TDBDIR
if [ -d $TDBDIR ]; then
    /bin/rm -rf $TDBDIR
fi
/bin/mkdir  $TDBDIR

# 3. Load ttl:
echo "Loading data into new tdb data directory:"
echo $TDBLOADER --loc $TDBDIR $TTL
$TDBLOADER --loc $TDBDIR $TTL

sudo chown -R vagrant $TDBDIR

# 4. Restart fuseki:
echo "Starting fuseki:  sudo $JENA --port=$PORT --config=$CONF"
$JENA --port=$PORT --config=$CONF
echo ""
echo Done.  SPARQL endpoint running on port $PORT.




