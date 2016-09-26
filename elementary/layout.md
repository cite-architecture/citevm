---
title: "Layout of the VM"
layout: page
---

## Technical reference

Layout of the VM

tomcat :

### Servlet container


`tomcat7` is running on port 8080, with CATALINA_HOME in `/usr/share/tomcat7` and CATALINA_BASE in `/var/lib/tomcat7`.  When the VM is provisioned, the file `/vagrant/system/tc-server.xml` is copied to  `/etc/tomcat7/server.xml`.  This defines a connector on port 8080 with proxying.


Configuration is in `/etc/default/tomcat7`



### SPARQL endpoint

`apache-jena` (for loading data with the `tdbloader2` tool) and `jena-fuseki` (the actual SPARQL endpoint) are both installed in `/opt`. The `load-ttl.sh` script uses the configuration file `system/fuseki-conf.ttl` to load data, then starts `fuseki-server` on port 3030.

**Important technical note**:  The `load-ttl.sh` script uses `tbdloader2` to load data into fuseki.  `tbdloader2` does not function when its tdb files are located in a directory shared with the host operating system, so `load-ttl.sh` places them in `/tmp`.
