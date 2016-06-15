###
#
# Syncthing
#
###

SYNCTHING_VERSION = 0.13.7
SYNCTHING_SOURCE = syncthing-source-v$(SYNCTHING_VERSION).tar.gz
SYNCTHING_SITE = https://github.com/syncthing/syncthing/releases/download/v$(SYNCTHING_VERSION)

SYNCTHING_LICENSE = Mozilla Public License Version 2.0
SYNCTHING_LICENSE_FILES = LICENSE.txt

SYNCTHING_DEPENDENCIES = host-go

SYNCTHING_MAKE_ENV = \
        $(HOST_GO_TARGET_ENV) \
        GOPATH="$(@D)" \

# Because Syncthing uses go vendoring and go vendoring does not seem to work well with symlinks
# (yet?) we extract the package into the path expected by Go.
# Symlink capabilities with vendor paths could possibly have been improved by this commit:
# https://github.com/golang/tools/commit/95963e031d86b0e7dafe40fde044d7f610404855
define SYNCTHING_EXTRACT_CMDS
	mkdir -p $(@D)/src/github.com/syncthing
	tar -xvzf $(BR2_DL_DIR)/$(SYNCTHING_SOURCE) -C $(@D)/src/github.com/syncthing
endef

define SYNCTHING_BUILD_CMDS
        cd $(@D)/src/github.com/syncthing/syncthing && $(SYNCTHING_MAKE_ENV) $(HOST_DIR)/usr/bin/go \
                run build.go build syncthing
endef

define SYNCTHING_USERS
        syncthing 8384 syncthing 8384 * /home/syncthing /bin/sh -
endef

define SYNCTHING_PERMISSIONS
        /home/syncthing d 700 8384 8384 - - - - -
endef

# TODO: use $(SYNCTHING_PKGDIR) once rpi-buildroot has been updated to buildroot 2015.11
# see: https://github.com/buildroot/buildroot/commit/235423870be6d9a97431eedac39ccd60eca17e25)
define SYNCTHING_INSTALL_TARGET_CMDS
	$(INSTALL) $(@D)/src/github.com/syncthing/syncthing/syncthing $(TARGET_DIR)/usr/bin
	$(INSTALL) $(BR2_EXTERNAL)/package/syncthing/syncthing-config.sh $(TARGET_DIR)/usr/bin
	$(INSTALL) $(BR2_EXTERNAL)/package/syncthing/syncthing-wrapped.sh $(TARGET_DIR)/usr/bin
	$(INSTALL) $(BR2_EXTERNAL)/package/syncthing/S60syncthing $(TARGET_DIR)/etc/init.d
endef

$(eval $(generic-package))
