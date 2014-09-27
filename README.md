# citevm #

Run a full suite of CITE services in a virtual machine provisioned by Vagrant to run either 64-bit or 32-bit Ubuntu 14.04.

## Quick start ##



### Build and run the VM

Start the VM either in 64-bit machne (default),

	vagrant up

 or in 32-bit OS (if your Windows BIOS prevents 64-bit OS):
 
    TINY=true vagrant up


### Build and run CITE services ###


Edit the three files `configs/*gradle` with appropriate values for your project, then in the VM run

    boot-cite.sh

Your CITE services should be available within the VM at `http://localhost`, and from your host OS at `http://localhost:8880/`


## More details ##

See the citevm manual, available in markdown format in the file `manual.md`, or from the [master branch of the project github repository](https://github.com/cite-architecture/citevm/blob/master/manual.md).



