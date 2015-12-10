Raspberry Pi with Syncthing
===========================

This is a project to provide Raspberry Pi with Syncthing installed. This is a buildroot *overlay* over rpi-buildroot.

Status
------

Development of this project has just started, so many rough edges and not even an inkling of a release schedule.

Next steps:
* Shell helper scripts to configure syncthing from the commandline
* Init script

Building
--------

You will need the buildroot requirements to start cross-compiling raspisync. See here: https://buildroot.org/downloads/manual/manual.html#requirement-mandatory.

On Ubuntu 15.04 I found it sufficient to install

    sudo apt-get install build-essential
    sudo apt-get install libncurses5-dev	# for make menuconfig

Download and build

    # none of these require root, execute as normal user
    git clone git://github.com/devste/raspisync.git
    cd raspisync
    make raspi2sync_defconfig
    make menuconfig	# not required, only if you want to change packages or configuration
    make

Deploying
---------

To create and **overwrite** an SD card with raspisync run the following script.

    sudo ./board/raspisync/mksdcard /dev/mmcblk0
    
**Notice** you will need to replace *mmcblk0* with the actual device node for your sdcard.

Load your SSH public key onto the SD card by following these steps.

    sudo mkdir /mnt/raspisynchome
    sudo mount /dev/mmcblk0p3 /mnt/raspisynchome	# the third partition on the SD card
    sudo mkdir -m 700 /mnt/raspihome/syncthing/.ssh
    sudo chown 8384:8384 /mnt/raspihome/syncthing/.ssh
    sudo cat ~/.ssh/id_rsa.pub >> /mnt/raspihome/.ssh/authorized_keys
    sudo chown 8384:8384 /mnt/raspihome/syncthing/.ssh/authorized_keys
    sudo umount /mnt/raspisynchome

After creating the SD card insert it into Raspberry Pi and boot the Raspberry Pi. You might have to boot once, then unplug the power from the Raspberry Pi and then boot it again and only then will it boot properly with network access.

Updating SD card
----------------

You can update the SD card by using the following command. The script will not touch the third partition (raspisynchome) and will only overwrite files on the other partitions, but never delete anything. As a side effect this will also preserve the host's public ssh key.

    sudo ./board/raspisync/udsdcard /dev/mmcblk0

Using
-----

You can setup the configuration for Syncthing by following these steps.

    ssh syncthing@raspisync	# It should use the SSH public key you supplied when setting up the SD card.
    syncthing-config.sh
    syncthing &

Tools
-----

The following command will be able to tell you if your SD card is properly set up. It will find the Raspisync SD card plugged into your system.

    ./board/raspisync/check-sdcard.sh
