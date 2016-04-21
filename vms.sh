#!/bin/bash

VMNAMES=($(virsh list --all | tr -s ' ' | cut -d' ' -f3))

for VM in "${VMNAMES[@]}"; do
	if [[ $VM != *"Name"* ]] && [[ $VM != *"---"* ]]; then
		VMIP=$(arp -ne -i virbr0 | grep "$(virsh domiflist "$VM" | grep -o "\(\(\w\{2\}:\)\{5\}\w\{2\}\)")" | grep -o "\([[:digit:]]\{1,3\}\.\)\{3\}[[:digit:]]\{1,3\}")
		echo "$VM $VMIP"
	fi
done
