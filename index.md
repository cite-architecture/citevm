---
title: citevm
layout: page
---

## Current development

The CITE virtual machine is being updated for the new version of citeservlet, [cs2](http://cite-architecture.github.io/cs2/), and the new [cite-archive-manager](https://github.com/cite-architecture/cite-archive-manager), both of which were developed in 2016.  The new VM includes a GUI running [Elementary OS](https://elementary.io/), and has passed initial tests on text, collection and image services.  In-progress documentation is being added [here](elementary).

We expect to release this version of the CITE VM in early October, 2016, but the current fully working version is available in the `elementary` branch of the repository for those who don't want to wait for documentation.

## Original CITE VM

In 2014, we published a virtual machine running a full suite of CITE services.

`citevm` provisions an Ubuntu 14.04 virtual machine with a full suite of tools for managing a suite of CITE repositories, building a unified RDF graph from all the repositories, serving the graph from a SPARQL endpoint, and working with the graph through a webapp.


- How to [build and configure `citevm`](build)
