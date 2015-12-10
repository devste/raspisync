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

	git clone git://github.com/devste/raspisync.git
	cd raspisync
	make raspi2sync_defconfig
	make menuconfig		# if you want to add packages or fiddle around with it
	make			# build (NOTICE: Don't use the **-j** switch, it's set to auto-detect)

Deploying
---------

To create and **overwrite** an SD card with raspisync run the following script.

    # run the following as root (sudo)
    board/raspisync/mksdcard /dev/mmcblk0
    
**Notice** you will need to replace *mmcblk0* with the actual device node for your sdcard.

Load your SSH public key onto the SD card by following these steps. All steps will require root/sudo.
* mkdir /mnt/raspisynchome
* mount /dev/mmcblk0p3 /mnt/raspisynchome (the third partition on the SD card)
* mkdir /mnt/raspihome
* cat ~/.ssh/id_rsa.pub >> /mnt/raspihome/.ssh/authorized_keys
* umount /mnt/raspisynchome

After creating the SD card insert it into Raspberry Pi and boot the Raspberry Pi. You might have to boot once, then unplug the power from the Raspberry Pi and then boot it again and only then will it boot properly with network access.

You can update the SD card by using the following command. The SD card will not touch the third partition (raspisynchome) and will only overwrite files on the other partitions, but never delete anything. This will also preserve the host's public ssh key.

    board/raspisync/udsdcard /dev/mmcblk0

Using
-----

You can setup the configuration for Syncthing by following these steps:
* Connect with 'ssh syncthing@raspisync'. It should use the SSH public key you supplied when setting up the SD card.
* Run syncthing-config.sh
* Run syncthing

Tools
-----

The following command will be able to tell you if your SD card is properly set up. It will find the Raspisync SD card plugged into your system.

	# can be run as non-root user
	board/raspisync/check-sdcard.sh
