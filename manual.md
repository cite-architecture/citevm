# citevm #

Run a full suite of CITE services in a virtual machine provisioned by Vagrant to run either 64-bit or 32-bit Ubuntu 14.04.

## Installing the system ##

### Prerequisites

- Vagrant: <http://www.vagrantup.com/downloads.html>
- VirtualBox: <https://www.virtualbox.org/wiki/Downloads>

The initial build requires internet access; after the initial build, you can run the virtual machine offline.


### Build the basic machine ###

As with any vagrant virtual machine, you can build the machine simply by bringing it up the first time:

	vagrant up

This will build the basic 64-bit Ubuntu system for CITE services.  Some Windows computers have default BIOS settings that prevent running a 64-bit VM.  Google is probably your best friend if you need to figure out what BIOS settings to change for your particular model of computer to allow running a 64-bit VM.  if you prefer not to change your BIOS settings, you can instead build a 32-bit guest machine by setting the environmental variable TINY to any value.  One way to do is to start the VM with the single line:

    TINY=true vagrant up



Once your virtual machine is runing, you can log in to your virtual machine:

    vagrant ssh
    

## Building and running your CITE project ##

The CITE services are provided by the `citeservlet` application:  you may configure it and add your own servlet pages to it as you wish for your project.  The servlet in turn draws all of its data from a SPARQL endpoint.  You can build the RDF graph, load it into the SPARQL endpoint, build the servlet, and load it into the servlet container with the single command:

    boot-cite.sh [-m MANAGER_CONF_FILE] [-c SERVLET_CONF_FILE] [-l SERVLET_LINKS_FILE] [-o CUSTOM_OVERLAY_DIRECTORY]

Its options are

- `-m`: configuration for `citemgr` to use in building RDF graph (default: `/vagrant/configs/managerconf.gradle`)
- `-c`: citeservlet configuration file (default: `/vagrant/configs/servletconf.gradle`)
- `-l`: citeservlet links file (default: `/vagrant/configs/servletlinks.gradle`)
 - `-o`: project's custom directory to overlay on citeservlet  (default: `/dev/null`)



As you develop your CITE project's data set or pages to customize your CITE servlet, you may need to update either the SPARQL endpoint or the servlet.   You can do that with this pair of scripts:


- `update-ttl.sh [-m MANAGER_CONF_FILE]`: builds the RDF graph for a project, and loads it in the SPARQL endpoint.  If  the `-m` option is given, it will be used as the configuration file for `citemgr`;  otherwise, the default configuration file in  `/vagrant/configs/managerconf.gradle` will be used.
- `update-servlet.sh [-c SERVLET_CONF_FILE] [-l SERVLET_LINKS_FILE] [-o CUSTOM_OVERLAY_DIRECTORY]`:  the options are the same as those used in the `boot-cite.sh` script.



## Using locally hosted files with CITE Image service ##

The binary pyramidal TIFF files that the CITE Image service are not normally part of a project's version control repository, but can easily be made available to the virtual machine from the host machine's file system.  The Vagrantfile that boots the virtual machine checks for an environmental variable named `PYRAMIDS`: if it is defined, vagrant attempts to mount a file system found in the host operating system at `PYRAMIDS`  at `/pyramids` in the VM. You can set the environmental variable and start the VM in a single line like this:

    PYRAMIDS=/Volumes/images/pyramids vagrant up

This example would start the VM, and make the host file system at `/Volumes/images/pyramids` visible in the VM at `/pyramids`.

Be sure that `citemgr`'s configuration for your project has the value of the `pyramids` property set to the VM directory `/pyramids`:

    pyramids = "/pyramids"

## Reference: layout of the VM ##

### Base box and provisioning

The virtual machine is based on a generic Ubuntu 14.04 machine from [Vagrant Cloud](https://vagrantcloud.com/), `puphpet/ubuntu1404-x64`, and is provisioned from the shell script `system/bootstrap.sh`.  All other data needed for provisioning the machine are also in the `system` directory.  The use of each file in the `system` directory is explained in the relevant section below.

In addition to Vagrant's standard mapping of `ssh` port 22 on the guest machine to port 2222 on the host machine, port 80 on the guest (web server) is mapped to port 8880 on the host machine and port 3030 on the guest (SPARQL endpoint) is mapped to port 3330 on the host.  Within the VM, the `cite-servlet` servlet is proxied to `http://localhost/cite`, so on your host machine, you can work with the `hmt-digital` application at `http://localhost:8880/cite`.


### Web server

`apache2` is running on port 80, with configuration in `/etc/apache2`, and web root in `/var/www/html`.  When the VM is provisioned, the file 
`/vagrant/system/000-default.conf-apache` is copied to `/etc/apache2/sites-available/000-default.conf`.  This defines a virtual host proxying the `hmt-digital` servlet from the servlet container running on port 8080.
In addition, the files in the `system/web` directory are copied to the server's web root.

### Servlet container

`tomcat6` is running on port 8080, with CATALINA_HOME in `/usr/share/tomcat6` and CATALINA_BASE in `/var/lib/tomcat6`.  When the VM is provisioned, the file `/vagrant/system/tc-server.xml` is copied to  `/etc/tomcat6/server.xml`.  This defines a connector on port 8080 with proxying.

### SPARQL endpoint

`apache-jena` (for loading data with the `tdbloader2` tool) and `jena-fuseki` (the actual SPARQL endpoint) are both installed in `/opt`. The `load-ttl.sh` script uses the configuration file `system/fuseki-conf.ttl` to load data, then starts `fuseki-server` on port 3030.

**Important technical note**:  The `load-ttl.sh` script uses `tbdloader2` to load data into fuseki.  `tbdloader2` does not function when its tdb files are located in a directory shared with the host operating system, so `load-ttl.sh` places them in `/tmp`.


### Image service

The  `iipsrv` fast-cgi is running on the VM at `http://localhost/iipsrv/iipsrv.fcgi` (so appears at `http://localhost:8880/iipsrv/iipsrv.fcgi` on your host machine).  When the VM is provisioned, it copies the configuration file `/vagrant/system/iipsrv.conf` to `/etc/apache2/mods-available/iipsrv.conf`.  Because Apache 2.4 is configured to execute only files within the `/usr/share` file system, when the VM is provisioned, it also copies the binary at `/usr/lib/iipimage-server/iipsrv.fcgi` to `/usr/share/iipimage-server/iipsrv.fcgi`.


### `vagrant` user account

When the VM is provisioned, the file `system/dotprofile` is copied to `$HOME/.profile`.  It sets values for PATH and the FUSEKI_HOME environmental variables.

Bash scripts for [rebuilding the HMT data graph](https://github.com/homermultitext/hmt-digital-vm/wiki/Rebuilding-the-data-graph) and for [updating the HMT servlet](https://github.com/homermultitext/hmt-digital-vm/wiki/Updating-the-servlet) are in the `scripts` directory (so available in the VM at `/vagrant/scripts`).  They are executable, and the vagrant user's account includes this directory in its PATH.


### Reference: scripts available in `/vagrant/bin` ###



Several scripts are located in `/vagrant/bin` (and therefore on the vagrant user's PATH).  


#### Scripts for installation of the CITE system ####


The script `refresh.sh` is invoked to install the CITE infrastructure in the initial provisioning of the VM. It in turn simply calls these three scripts:

- `web.sh`:  copies content in `/vagrant/system/web` to the apache web server
- `get-jena.sh`:  installs jena-fuseki (server) and apache-jena (tools, including load tools)
- `pull-repos.sh`:  clones or, if already cloned, updates the `citemgr` and `citeservlet` repositories in `/vagrant/repositories`

You can also run any of these scripts separately or together to refresh or reinstall parts of your CITE system after the initial build of the VM.



### Scripts for building and updating your CITE application ###



While `update-ttl.sh` and `update-servlet.sh` are likely to be all you will need to build and run your CITE system, they actually call the following scripts which are also available if you want to run any of them individually:

- `build-ttl.sh`:  uses `citemgr` to build the RDF graph for a project.  An optional parameter may give the file name of a configuration file for `citemgr` (default: `/vagrant/configs/managerconf.gradle`)
- `load-ttl.sh`:    (re)loads TTL data and (re)starts fuseki server
- `build-war.sh`: builds a `.war` file for a project's `citeservlet` app.  Command-line options it recognizes (with default values) are:
    - `-c`: citeservlet conf file (default: `/vagrant/configs/servletconf.gradle`)
    - `-l`: citeservlet links file (default: `/vagrant/configs/servletlinks.gradle`)
    - `-o`: project's custom directory to overlay on citeservlet  (default: `/dev/null`)
    - `-s`: directory citeservlet repository (default: `/vagrant/repositories/citeservlet`)
- `run-war.sh`:  installs the `.war` file built by `build-war.sh` in tomcat, and restarts tomcat

The file `boot-cite.sh` runs these four scripts in the following order to  build and run a CITE project from scratch:

    build-ttl.sh
    load-ttls.sh
    build-war.sh
    run-war.sh




