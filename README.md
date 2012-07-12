Using RiceBox
========================

RiceBox is a Vagrant playground for Kuali RICE.  To use it, you'll need Vagrant, VirtualBox, and an Ubuntu 12.04 Vagrant box.

Setting up Vagrant
----------------------

The best instructions for setting up Vagrant can be found at 
http://vagrantup.com/v1/docs/getting-started/index.html. The instructions that follow should provide the minimal steps to get started quickly.

1. ###Install VirtualBox
<https://www.virtualbox.org/wiki/Downloads>

2. ###Install Vagrant
<http://downloads.vagrantup.com/tags/v1.0.3>

3. ###Download and install the Ubuntu 12.04 Vagrant box

        $ vagrant box add precise32 http://files.vagrantup.com/precise32.box

4. ###Download and install git
<http://git-scm.com/downloads>
    
5. ###Checkout this GitHub project

        $ mkdir $HOME/vagrant
        $ cd $HOME/vagrant
        $ git clone https://github.com/jeremiahshirk/ricebox.git
        $ cd ricebox

6. ###Start the virtual machine

        $ vagrant up
        
    This will take a while the first time, as Chef gets all of the RICE dependencies in place, configures the database, etc.

7. ###Log in
<http://localhost:8080/kr-dev/>

    The default username for the demo is _admin_.
    
TODO
------------------

The project still needs quite a bit of clean up. 

- Move hard-coded values into attributes
- Pull RICE specific parts of vagrant_main into a RICE cookbook