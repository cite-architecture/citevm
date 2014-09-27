# citevm #

Run full suite of CITE services in an Ubuntu virtual machine.



## Using locally hosted files with CITE Image service ##


The Vagrantfile that boots the virtual machine checks for an environmental variable named `PYRAMIDS`: if it is defined, it attempts to mount a file system found in the host operating system at `PYRAMIDS`  at `/pyramids` in the VM. You can set the environmental variable and start the VM in a single line like this:

    PYRAMIDS=/Volumes/images/pyramids vagrant up

This example would start the VM, and make the host file system at `/Volumes/images/pyramids` visible in the VM at `/pyramids`.

