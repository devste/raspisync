###
# fail2ban
###

FAIL2BAN_VERSION = 0.9.3
FAIL2BAN_SOURCE = $(PYTHON_FAIL2BAN_VERSION).tar.gz
FAIL2BAN_SITE = https://github.com/fail2ban/fail2ban/archive
FAIL2BAN_LICENSE = GPLv2
FAIL2BAN_ENV = install
FAIL2BAN_SETUP_TYPE = setuptools

# TODO: use $(FAIL2BAN_PKGDIR) once rpi-buildroot has been updated to buildroot 2015.11
# see: https://github.com/buildroot/buildroot/commit/235423870be6d9a97431eedac39ccd60eca17e25)
#define SYNCTHING_INSTALL_TARGET_CMDS
#	$(INSTALL) $(@D)/syncthing $(TARGET_DIR)/usr/bin
#	$(INSTALL) package/syncthing/syncthing-config.sh $(TARGET_DIR)/usr/bin
#	$(INSTALL) package/syncthing/syncthing-wrapped.sh $(TARGET_DIR)/usr/bin
#	$(INSTALL) package/syncthing/S60syncthing $(TARGET_DIR)/etc/init.d
#endef

$(eval $(python-package))
