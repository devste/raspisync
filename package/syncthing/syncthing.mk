###
# Syncthing (arm binary)
###

SYNCTHING_VERSION = 0.12.6
SYNCTHING_SOURCE = syncthing-linux-arm-v$(SYNCTHING_VERSION).tar.gz
SYNCTHING_SITE = https://github.com/syncthing/syncthing/releases/download/v$(SYNCTHING_VERSION)

SYNCTHING_LICENSE = Mozilla Public License Version 2.0
SYNCTHING_LICENSE_FILES = LICENSE.txt

define SYNCTHING_USERS
        syncthing 8384 syncthing 8384 =syncthing /home/syncthing /bin/sh -
endef

define SYNCTHING_PERMISSIONS
        /home/syncthing d 700 8384 8384 - - - - -
endef

define SYNCTHING_INSTALL_TARGET_CMDS
	$(INSTALL) $(@D)/syncthing $(TARGET_DIR)/usr/bin
endef

$(eval $(generic-package))
