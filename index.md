---
title: citevm
layout: page
---

## Current development

The CITE virtual machine is being updated for the new version of citeservlet (`cs2`) and the new `cite-archive-manager` that are under development in 2016.  The new VM will include a GUI running Elementary OS.  In-progress notes and documenation are being put [here](elementary).

The first release will include `cs2` with a fully tested CTS subproject, whether or not other CITE services in `cs2` have been fully developed to a release-quality version.

## Original CITE VM

In 2014, we published a virtual machine running a full suite of CITE services.

`citevm` provisions an Ubuntu 14.04 virtual machine with a full suite of tools for managing a suite of CITE repositories, building a unified RDF graph from all the repositories, serving the graph from a SPARQL endpoint, and working with the graph through a webapp.


- How to [build and configure `citevm`](build)
