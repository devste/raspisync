Raspberry Pi with Syncthing
===========================

This is a project to provide Raspberry Pi with Syncthing installed.

Status
------

Development of this project has just started, see the preliminary plans under https://github.com/devste/raspisync/milestones

Building
--------

You will need the buildroot requirements to start cross-compiling raspisync. See here: https://buildroot.org/downloads/manual/manual.html#requirement-mandatory.

Vagrant workflow
----------------

This is the suggested workflow. It will download quite a bit of data, so best be on a fixed line and be prepared to drink some coffee.

    git clone git://github.com/devste/raspisync.git
    cd raspisync
    vagrant up
    vagrant ssh
    cd raspisync
    git submodule init
    git submodule update
    make prepare
    make

Development host workflow
-------------------------

On Ubuntu 16.04 it should be sufficient to install

    sudo apt-get install build-essential
    # If you want to use make menuconfig, install the following:
    sudo apt-get install libncurses5-dev

Download and build

    # none of these require root, execute as normal user
    git clone git://github.com/devste/raspisync.git
    cd raspisync
    git submodule init
    git submodule update
    make prepare
    # if you want to change some configuration
    cd buildroot && make menuconfig && cd ..
    make

Deploying
---------

To create and **overwrite** an SD card with raspisync run the following script.

    sudo ./sdcard-tools/mksdcard /dev/mmcblk0
    
**Notice** you will need to replace *mmcblk0* with the actual device node for your sdcard.

Load your SSH public key onto the SD card to allow root access.

    sudo mkdir /mnt/raspisynchome
    sudo mount /dev/mmcblk0p3 /mnt/raspisynchome	# the third partition on the SD card
    sudo mkdir -m 700 /mnt/raspihome/root/.ssh
    sudo cat ~/.ssh/id_rsa.pub >> /mnt/raspihome/root/.ssh/authorized_keys
    sudo umount /mnt/raspisynchome

After creating the SD card insert it into Raspberry Pi and boot the Raspberry Pi. 

Updating SD card
----------------

You can update the SD card by using the following command. The script will not touch the third partition (raspisynchome) and will only overwrite files on the other partitions, but never delete anything. As a side effect this will also preserve the host's public ssh key.

    sudo ./sdcard-tools/udsdcard /dev/mmcblk0

Using
-----

The raspisync comes preloaded with an init-script that starts syncthing automatically. If syncthing hasn't been configured yet, it will also start the configuration script. Should this fail, then you can run the script manually by following these commands:

    ssh root@raspisync	# It should use the SSH public key you supplied when setting up the SD card.
    syncthing-config.sh
    exit
    /etc/init.d/S60syncthing start

Tools
-----

The following command can be used on the host system to tell you wether your SD card is properly set up with raspisync. It looks at the partitions on the SD card to determine if this is the case.

    ./sdcard-tools/check-sdcard.sh

History
-------

This project started as a fork or rpi-buildroot, then integrated the official buildroot sources. Now it is organised with buildroot as a submodule.
