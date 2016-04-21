#!/bin/bash

NEWVM="${1?Please enter a VM name}"
DISKIMG=$(virsh dumpxml "$NEWVM" | grep 'source file' | cut -d"'" -f 2)

virsh destroy "$NEWVM"
virsh undefine "$NEWVM"
rm -i "$DISKIMG"
