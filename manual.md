# citevm #

Run a full suite of CITE services in a virtual machine provisioned by Vagrant to run either 64-bit or 32-bit Ubuntu 14.04.


## Caveat for Windows users ##

Some Windows machines have default BIOS settings that prevent running a 64-bit VM.  Google is probably your best friend if you need to figure out what BIOS settings to change for your particular model of computer.

The default setting installs a 64-bit guest machine.  You can override this and run a 32-bit guest machine by setting the environmental variable TINY to any value.  You can start the VM with a 32-bit machine with the single line:

    TINY=true vagrant up
    
## Scripts to install and run CITE services ##

Several scripts are located in `/vagrant/bin` (and therefore on the vagrant user's PATH).  


### Installation of the CITE system ###


The script `refresh.sh` is evoked to install the CITE infrastructure in the initial provisioning of the VM. It in turn simply calls these three scripts:

- `web.sh`:  copies content in `/vagrant/system/web` to the apache web server
- `get-jena.sh`:  installs jena-fuseki (server) and apache-jena (tools, including load tools)
- `pull-repos.sh`:  clones or, if already cloned, updates the `citemgr` and `citeservlet` repositories in `/vagrant/repositories`

You can also run any of these scripts separately or together to refresh or reinstall parts of your CITE system after the initial build of the VM.

### Building and running a CITE system for a specific project ###


The following scripts are used to build the TTL graph for a project, and load it in
a SPARQL endpoint.


- `build-ttl.sh`:  uses `citemgr` to build the RDF graph for a project.  An optional parameter may give the file name of a configuration file for `citemgr` (default: `/vagrant/configs/managerconf.gradle`)
- `load-ttl.sh`:    (re)loads TTL data and (re)starts fuseki server

These scripts may be used to (re)build and install a servlet.

- `build-war.sh`: builds a `.war` file for a project's `citeservlet` app.  Command-line options it recognizes (with default values) are:
    - `-c`: citeservlet conf file (default: `/vagrant/configs/servletconf.gradle`)
    - `-l`: citeservlet links file (default: `/vagrant/configs/servletlinks.gradle`)
    - `-o`: project's custom directory to overlay on citeservlet  (default: `/dev/null`)
    - `-s`: directory citeservlet repository (default: `/vagrant/repositories/citeservlet`)
- `run-war.sh`:  installs the `.war` file built by `build-war.sh` in tomcat, and restarts tomcat

The file `boot-cite.sh` runs these four scripts in the following order to  build and run a CITE project from scratch, using default values for all configuration files:

    build-ttl.sh
    load-ttls.sh
    build-war.sh
    run-war.sh

You can edit the configuration files in `/vagrant/configs` with appropriate values for your system and then run `boot-cite.sh`.  You can also clone this `boot-cite.s` if your prefer to modify the default configuration settings: see the comments in the script for examples.  



## Using locally hosted files with CITE Image service ##

The binary pyramidal TIFF files that the CITE Image service are not normally part of a project's version control repository, but can easily be made available to the virtual machine from the host machine's file system.  The Vagrantfile that boots the virtual machine checks for an environmental variable named `PYRAMIDS`: if it is defined, vagrant attempts to mount a file system found in the host operating system at `PYRAMIDS`  at `/pyramids` in the VM. You can set the environmental variable and start the VM in a single line like this:

    PYRAMIDS=/Volumes/images/pyramids vagrant up

This example would start the VM, and make the host file system at `/Volumes/images/pyramids` visible in the VM at `/pyramids`.

Be sure that `citemgr`'s configuration for your project has the value of the `pyramids` property set to the VM directory `/pyramids`:

    pyramids = "/pyramids"


