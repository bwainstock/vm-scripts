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
  virt-sysprep -d "$NEWVM" --enable udev-persistent-net,bash-history,logfiles,utmp,net-hostname,customize --firstboot-command "$FIRSTBOOTCMDDHCP"
else
  virt-sysprep -d "$NEWVM" --enable udev-persistent-net,bash-history,logfiles,utmp,net-hostname,customize --firstboot-command "$FIRSTBOOTCMD"
fi 

if [ -z "$IP" ]
then
  virt-sysprep -d "$NEWVM" --hostname "$NEWVM" --script "$CONFIGSCRIPTDHCP"
else
  virt-sysprep -d "$NEWVM" --hostname "$NEWVM" --script "$CONFIGSCRIPT"
fi
virsh start "$NEWVM"
