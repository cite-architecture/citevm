#!/usr/bin/env /bin/bash

GIT=`which git`


# cite manager
if [ -d "/vagrant/repositories/citemgr" ]; then
    echo "Checking for updates to citemgr."
    cd /vagrant/repositories/citemgr
    $GIT pull
else
    echo "Installing citemgr."
    cd /vagrant/repositories
    echo  Running  $GIT https://github.com/cite-architecture/citemgr.git
    $GIT clone https://github.com/cite-architecture/citemgr.git
fi


# citeservlet
if [ -d "/vagrant/repositories/citeservlet" ]; then
    echo "Checking for updates to citeservlet."
    cd /vagrant/repositories/citeservlet
    $GIT pull
else
    echo "Installing citeservlet."
    cd /vagrant/repositories
    echo  Running  $GIT https://github.com/cite-architecture/citeservlet.git
    $GIT clone https://github.com/cite-architecture/citeservlet.git
fi


