#!/bin/bash

# Include the bsfl library
declare -r DIR=$(cd "$(dirname "$0")" && pwd)
source $DIR/bsfl/lib/bsfl.sh

msg "Checking for plugged-in Raspisync SD cards and partitions"

find_top_level_block() {
	maindev=`echo "${1}" | grep -B 1 RASPISYNC | sed -n 1p | xargs`
	blockmaindev="/dev/${maindev}"
	if [ "${maindev}" == "" ]; then
		msg_error "No block device with a Raspisync boot partition found. Exiting."
		exit 1
	fi
	if [ -b "${blockmaindev}" ]; then
		msg_ok "${blockmaindev} is a block device."
	else
		msg_error "${blockmaindev} is not a block device. Exiting."
		exit 1
	fi
}

## Scan partition names freely, just useful debug output
scan_partitions_freely() {
	echo "Device lines with Raspisync"
	echo "Boot:"
	echo "${1}" | grep "RASPISYNC"
	echo "Root:"
	echo "${1}" | grep "raspisyncRoot"
	echo "Home:"
	echo "${1}" | grep "raspisyncHome"
}

get_maindev_scheme() {
	if [ `echo "${1}" | grep -c "mmcblk"` -eq 1 ]; then
        	devscheme="${maindev}p"
	else
        	devscheme="${maindev}"
	fi
}

## Check boot partition
## The following values should be passed. Only if all of them are fulfilled is the partition considered to be valid.
# @params $1: partition
# @params $2: filesystem type
# @params $3: label
# @params $4: minimum size (in MegaBytes - not MibiBytes)
check_part() {
	__human_name=${1}
	__dev=${2}
	__fstype=${3}
	__label=${4}
	__minsize=${5}
	__minsize_bytes=$(( $5 * 1000000 ))
	if [ `echo "${lsblkout}" | grep -c -e "^.*${__dev}.*${__fstype}.*${__label}.*$"` -eq 1 ]; then
        	msg_ok "${__human_name}: Device name, fstype and label look good."
	else
	        msg_error "${__human_name}: Device name, fstype or label don't fulfill our expectations"
	fi
	if [ `lsblk --bytes /dev/"${__dev}" | awk '{print $4}' | sed -n 2p` -ge $__minsize_bytes ]; then
		msg_ok "Current size is larger than required ${__minsize} MB"
	else
		msg_error "Current size is not large enough. Expected at least ${__minsize} MB"
	fi
}

lsblkout=`lsblk --fs`
find_top_level_block "${lsblkout}"
get_maindev_scheme "${maindev}"
part_boot="${devscheme}1"
part_root="${devscheme}2"
part_home="${devscheme}3"
check_part "Raspisync boot" ${part_boot} vfat RASPISYNC 32
check_part "Raspisync root" ${part_root} ext4 raspisyncRoot 600
check_part "Raspisync home" ${part_home} ext4 raspisyncHome 0
