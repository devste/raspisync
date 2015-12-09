###
# Syncthing (arm binary)
###

SYNCTHING_VERSION = 0.12.6
SYNCTHING_SOURCE = syncthing-linux-arm-v$(SYNCTHING_VERSION).tar.gz
SYNCTHING_SITE = https://github.com/syncthing/syncthing/releases/download/v$(SYNCTHING_VERSION)

SYNCTHING_LICENSE = Mozilla Public License Version 2.0
SYNCTHING_LICENSE_FILES = LICENSE.txt

define SYNCTHING_USERS
        syncthing 8384 syncthing 8384 - /home/syncthing /bin/sh -
endef

define SYNCTHING_PERMISSIONS
        /home/syncthing d 700 8384 8384 - - - - -
endef

# TODO: use $(SYNCTHING_PKGDIR) once rpi-buildroot has been updated to buildroot 2015.11
# see: https://github.com/buildroot/buildroot/commit/235423870be6d9a97431eedac39ccd60eca17e25)
define SYNCTHING_INSTALL_TARGET_CMDS
	$(INSTALL) $(@D)/syncthing $(TARGET_DIR)/usr/bin
	$(INSTALL) package/syncthing/syncthing-config.sh $(TARGET_DIR)/usr/bin
endef

$(eval $(generic-package))
