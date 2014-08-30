#!/usr/bin/env /bin/bash

GRADLE=`which gradle`
GIT=`which git`
MV=`which mv`

# If no args, exit with error msg...

REPOS=$1

BRANCH="master"
if [ "$#" -eq 2 ]; then
    BRANCH=$2
fi
echo "Checking out branch ${BRANCH} of $REPOS"
cd /vagrant/repositories/$REPOS
$GIT checkout $BRANCH

$GRADLE clean
$GRADLE allTtl




