Raspberry Pi with Syncthing
===========================

This is a project to provide Raspberry Pi with Syncthing installed. This is a buildroot *overlay* over rpi-buildroot.

Status
------

Development of this project has just started, so many rough edges and not even an inkling of a release schedule.

Next steps:
* Upgrade script for SD card (to only upgrade the system, but not the data partition)

Building
--------

	git clone git://github.com/devste/raspisync.git
	cd raspisync
	make raspisync_defconfig
	make menuconfig		# if you want to add packages or fiddle around with it
	make			# build (NOTICE: Don't use the **-j** switch, it's set to auto-detect)

Deploying
---------

I've added a script that can automatically flash your sdcard, you simply need
to point it to the correct device node, confirm and you're done!

**Notice** you will need to replace *mmcblk0* in the following commands with the
actual device node for your sdcard.

    # run the following as root (sudo)
    board/raspisync/mksdcard /dev/mmcblk0

After creating the SD card insert it into Raspberry Pi and run the distribution.

Using
-----

There is not much to do with the current state of the project.


* Connect with 'ssh syncthing@raspisync' (password: syncthing). Assuming you are on the same network as the raspisync
* Start syncthing

* Change the webinterface access to 0.0.0.0:8384 in /home/syncthing/.config/syncthing/config.xml
* Use your browser to connect to raspisync:8384

Tools
-----

The following command will be able to tell you if your SD card is properly set up. It will find the Raspisync SD card plugged into your system.

	# can be run as non-root user
	board/raspisync/check-sdcard.sh
