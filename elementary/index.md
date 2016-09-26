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

## Demos

- add demo file with sample of HMT TTL
- build Anne Frank archive from scratch


## Building and serving your own CITE project

There are two parts to serving an archive of CITE data:

1. building an RDF of the project.  Here's how to do that.
2. loading it into a SPARQL endpoint.  Here's how to [build and load RDF](./rdf-build) in your VM.


The VM installs three generic CITE services as tomcat servlets: `texts` is a CTS service, `collections` is a CITE Collection service, and `images` is a service supporting the CITE Image Extension.  The Tomcat installation also includes a landing page named `cs2` linking to the three services.

You can of course install your own servlets under tomcat, or add your own client applications that talk to any of the three services.


## Running stuff

Start fuseki: `load-ttl.sh`.  

TBD:

- add option to supply ttl file name.
