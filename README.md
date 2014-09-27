# citevm #

Run full suite of CITE services in a virtual machine provisioned by Vagrant to run 64-bit Ubuntu 14.04.

## Caveat ##

Some Windows machines have default BIOS settings that prevent running a 64-bit VM.  Google is probably your best friend if you need to figure out what BIOS settings to change for your particular model of computer.

## Scripts to install and run CITE services ##

Several scripts are located in `/vagrant/bin` (and therefore on the vagrant user's PATH).  


### Installation of the CITE system ###


The following three scripts are evoked by `refresh.sh` to install the initial CITE system.  Ultimately, this should be evoked in the initial provisioning of the VM (but currently is is not).

- `web.sh`:  copies content in `/vagrant/system/web` to the apache web server
- `get-jena.sh`:  installs jena-fuseki (server) and apache-jena (tools, including load tools)
- `pull-repos.sh`:  clones or, if already cloned, updates the `citemgr` and `citeservlet` repositories in `/vagrant/repositories`

### Building and running a CITE system for a specific project ###


The following scripts are used to build the TTL graph for a project, and load it in
a SPARQL endpoint.

*Not fully modified yet from model in hmt-digital-vm*

- `build-ttl.sh`:  
- `build-img-ttl.sh`  
- `load-ttl.sh`:    

These scripts may be used to 
- `build-war.sh`: builds a `.war` file for a project's `citeservlet` app.  Parameters to the script should give the three citeservlet configuration files (`conf`, `links` and `custom` overlay), and optionally a branch of the citeservlet repository to build from.  (Default is `master`.)
- `run-war.sh`:  installs the `.war` file built by `build-war.sh` in tomcat, and restarts tomcat


## Using locally hosted files with CITE Image service ##


The Vagrantfile that boots the virtual machine checks for an environmental variable named `PYRAMIDS`: if it is defined, it attempts to mount a file system found in the host operating system at `PYRAMIDS`  at `/pyramids` in the VM. You can set the environmental variable and start the VM in a single line like this:

    PYRAMIDS=/Volumes/images/pyramids vagrant up

This example would start the VM, and make the host file system at `/Volumes/images/pyramids` visible in the VM at `/pyramids`.

