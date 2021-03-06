#!/bin/bash

BASEIMG=centos7-clone
CONFIGSCRIPT=$(pwd)/vmtemplates/configure.sh
CONFIGSCRIPTDHCP=$(pwd)/vmtemplates/configure-dhcp.sh
NEWVM="${1?Please enter a VM name}"
NEWVMDISK="/run/media/tigren/Data/Misc/$NEWVM.qcow2"
IP="$2"

echo "$NEWVM"
echo "$NEWVMDISK"
if [ -e "$NEWVMDISK" ]
then
  echo "Disk image already exists: $NEWVMDISK"
  exit
fi

virt-clone -o "$BASEIMG" -n "$NEWVM" -f "$NEWVMDISK"

if [ -z "$IP" ]
then
  virt-sysprep  -d "$NEWVM" --hostname "$NEWVM" --script "$CONFIGSCRIPTDHCP"
else
  virt-sysprep  -d "$NEWVM" --hostname "$NEWVM" --script "$CONFIGSCRIPT $IP"
fi

virsh start "$NEWVM"
