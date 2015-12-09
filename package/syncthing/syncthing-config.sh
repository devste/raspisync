#!/bin/sh

echo "Raspisync Syncthing configuration"

ST_BIN=`which syncthing`
ST_CONF_DIR=${HOME}/.config/syncthing
ST_CONF=${ST_CONF_DIR}/config.xml

if [ -e ${ST_CONF} ]; then
	echo "Configuration file exists already. Will not overwrite an existing configuration. Exiting."
	echo "File: ${ST_CONF}"
	exit 1
fi

echo "Setting up key and config"
${ST_BIN} --generate=${ST_CONF_DIR}

# Change directory due to all the backup files created
cd ${ST_CONF_DIR}

echo "Disabling GUI"
sed -i.gui.bak -e 's/<gui enabled="true"/<gui enabled="false"/' ${ST_CONF} 

echo "Disabling automatic updates"
sed -i.autoupdate.bak -r 's/<autoUpgradeIntervalH>.+?<\/autoUpgradeIntervalH>/<autoUpgradeIntervalH>0<\/autoUpgradeIntervalH>/' ${ST_CONF}

echo "Disabling UPnP"
sed -i.upnp.bak -r 's/<upnpEnabled>true<\/upnpEnabled>/<upnpEnabled>false<\/upnpEnabled>/' ${ST_CONF}
