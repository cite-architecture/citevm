---
title: "Elementary CITE VM"
layout: page
---

### Prerequisites

- Vagrant: <http://www.vagrantup.com/downloads.html>
- VirtualBox: <https://www.virtualbox.org/wiki/Downloads>

The initial build requires internet access; after the initial build, you can run the virtual machine offline.

## Installation

From a terminal in the `citevm` directory, the command

    vagrant up

starts the virtual machine.  If you have never run the VM before, Vagrant will first build the virtual machine, then start it.  This can take some time, depending on the speed of your host machine and your internet connection.


## Building and serving a CITE project

There are two parts to serving an archive of CITE data:

1. build an RDF of the project, and load it into a SPARQL endpoint.  Here's how to [build and load RDF](./rdf-build) in your VM.
2. install a client to work with the the SPARQL data.  Here's how to install the [generic CITE servlet `cs2`](./cs2) in your VM



## Technical reference

Layout of the VM

tomcat :

### Servlet container


`tomcat7` is running on port 8080, with CATALINA_HOME in `/usr/share/tomcat7` and CATALINA_BASE in `/var/lib/tomcat7`.  When the VM is provisioned, the file `/vagrant/system/tc-server.xml` is copied to  `/etc/tomcat7/server.xml`.  This defines a connector on port 8080 with proxying.


Configuration is in `/etc/default/tomcat7`



### SPARQL endpoint

`apache-jena` (for loading data with the `tdbloader2` tool) and `jena-fuseki` (the actual SPARQL endpoint) are both installed in `/opt`. The `load-ttl.sh` script uses the configuration file `system/fuseki-conf.ttl` to load data, then starts `fuseki-server` on port 3030.

**Important technical note**:  The `load-ttl.sh` script uses `tbdloader2` to load data into fuseki.  `tbdloader2` does not function when its tdb files are located in a directory shared with the host operating system, so `load-ttl.sh` places them in `/tmp`.
