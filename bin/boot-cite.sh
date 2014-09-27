#!/usr/bin/env /bin/bash
#
# Run through full CITE service build and boot sequence,
# using default settings for all configuration files.


# Builds RDF graph using configuration in /vagrant/configs/managerconf.gradle. 
# To use a different configuration file:
#
# /vagrant/bin/build-ttl.sh FILENAME
/vagrant/bin/build-ttl.sh


# Loads the newly built RDF graph in fuseki using the configuration
# in /vagrant/system/fuseki-conf.ttl, and reboots fuseki.
/vagrant/bin/load-ttls.sh


# Builds a war file for a CITE project.  To override default setings
# for configuration, use any of these command-line options:
#
# /vagrant/bin/build-war.sh -c SERVLETCONF -l SERVLETLINKS -o CUSTOMEROVERLAY
/vagrant/bin/build-war.sh

# Installs newly built war file in tomcat and reboots tomcat.
/vagrant/bin/run-war.sh
