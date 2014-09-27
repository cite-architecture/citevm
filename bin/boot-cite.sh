#!/usr/bin/env /bin/bash
#
# Run through full CITE service build and boot sequence,
# using default settings for all configuration files.


/vagrant/bin/build-ttl.sh
/vagrant/bin/load-ttls.sh
/vagrant/bin/build-war.sh
/vagrant/bin/run-war.sh
