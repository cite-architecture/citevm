#!/usr/bin/env /bin/bash

# Install web pages
/vagrant/bin/web.sh

# Installl jena
/vagrant/bin/get-jena.sh

# Pull on all repositories
/vagrant/bin/pull-repos.sh
