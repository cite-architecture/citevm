#!/usr/bin/env /bin/bash
#
# run cite-archive-manager, and copy output to data area

GRADLE=`which gradle`
CP=`which cp`

cd /vagrant/cite-archive-manager
echo "Using cite-archive-manager to build ttl..."
$GRADLE ctsttl
echo ""
echo "Copying resulting TTL to /vagrant/data.."
$CP /vagrant/cite-archive-manager/build/ttl/*ttl /vagrant/data
echo "Done."
