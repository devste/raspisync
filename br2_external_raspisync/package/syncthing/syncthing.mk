###
#
# Syncthing
#
###

SYNCTHING_VERSION = 0.14.0
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

# For raspisync: install the user "syncthing" and set the permissions accordingly
define SYNCTHING_USERS
        syncthing 8384 syncthing 8384 * /home/syncthing /bin/sh -
endef
define SYNCTHING_PERMISSIONS
        /home/syncthing d 700 8384 8384 - - - - -
endef

define SYNCTHING_INSTALL_TARGET_CMDS
	$(INSTALL) $(@D)/src/github.com/syncthing/syncthing/syncthing $(TARGET_DIR)/usr/bin
# These three actions are raspisync-specific
	$(INSTALL) $(SYNCTHING_PKGDIR)/syncthing-config.sh $(TARGET_DIR)/usr/bin
	$(INSTALL) $(SYNCTHING_PKGDIR)/syncthing-wrapped.sh $(TARGET_DIR)/usr/bin
	$(INSTALL) $(SYNCTHING_PKGDIR)/S60syncthing $(TARGET_DIR)/etc/init.d
endef

$(eval $(generic-package))
