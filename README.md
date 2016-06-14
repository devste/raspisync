Raspberry Pi with Syncthing
===========================

This is a project to provide Raspberry Pi with Syncthing installed. This is a buildroot *overlay*, based on rpi-buildroot (now downstreaming directly from the official buildroot sources).

Status
------

Development of this project has just started, see the preliminary plans under https://github.com/devste/raspisync/milestones

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
    make BR2_EXTERNAL=br2_external_raspisync/ raspi2sync_defconfig
    make menuconfig	# not required, only if you want to change packages or configuration
    make

Deploying
---------

To create and **overwrite** an SD card with raspisync run the following script.

    sudo ./br2_external_raspisync/board/raspisync/mksdcard /dev/mmcblk0
    
**Notice** you will need to replace *mmcblk0* with the actual device node for your sdcard.

Load your SSH public key onto the SD card to allow root access.

    sudo mkdir /mnt/raspisynchome
    sudo mount /dev/mmcblk0p3 /mnt/raspisynchome	# the third partition on the SD card
    sudo mkdir -m 700 /mnt/raspihome/root/.ssh
    sudo cat ~/.ssh/id_rsa.pub >> /mnt/raspihome/root/.ssh/authorized_keys
    sudo umount /mnt/raspisynchome

After creating the SD card insert it into Raspberry Pi and boot the Raspberry Pi. 

Under some circumstances you might have to boot once, then unplug the power from the Raspberry Pi and then boot it again and only then will it boot properly with network access.

Updating SD card
----------------

You can update the SD card by using the following command. The script will not touch the third partition (raspisynchome) and will only overwrite files on the other partitions, but never delete anything. As a side effect this will also preserve the host's public ssh key.

    sudo ./board/raspisync/udsdcard /dev/mmcblk0

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

    ./board/raspisync/check-sdcard.sh
