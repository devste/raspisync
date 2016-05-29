#!/bin/sh

echo "Raspisync Syncthing configuration"

ST_BIN=`which syncthing`
ST_CONF_DIR=${HOME}/.config/syncthing
ST_CONF=${ST_CONF_DIR}/config.xml

if [ -e ${ST_CONF} ]; then
	echo "Configuration file exists already. Will modify existing configuration file."
	echo "File: ${ST_CONF}"
else
	echo "Creating key and configuration file"
	${ST_BIN} --generate=${ST_CONF_DIR}
fi

# Change directory due to all the backup files created
cd ${ST_CONF_DIR}

echo "Enforcing TLS on GUI"
sed -i.gui-tls.bak -e 's/<gui enabled=".*" tls=".*"/<gui enabled="true" tls="true"/' ${ST_CONF} 

echo "Disabling automatic updates"
sed -i.autoupdate.bak -r 's/<autoUpgradeIntervalH>.+?<\/autoUpgradeIntervalH>/<autoUpgradeIntervalH>0<\/autoUpgradeIntervalH>/' ${ST_CONF}

echo "Disabling UPnP"
sed -i.upnp.bak -r 's/<upnpEnabled>true<\/upnpEnabled>/<upnpEnabled>false<\/upnpEnabled>/' ${ST_CONF}

echo "Disabling browser start"
sed -i.browser.bak -r 's/<startBrowser>true<\/startBrowser>/<startBrowser>false<\/startBrowser>/' ${ST_CONF}

echo "Allowing GUI access from the network"
# Backup file first
cp ${ST_CONF} ${ST_CONF}.gui-open.bak
# Transform to single-line file
cat ${ST_CONF} | tr '\n' '\r' > ${ST_CONF}.tmp.gui-open
# Replace IP address
sed -i.bak -r 's;(.*)<gui(.*)>(.*)<address>(.*):(.*)</address>(.*)</gui>(.*);\1<gui\2>\3<address>0.0.0.0:\5</address>\6</gui>\7;' ${ST_CONF}.tmp.gui-open
# Write the new config file back
cat ${ST_CONF}.tmp.gui-open | tr '\r' '\n' > ${ST_CONF}
