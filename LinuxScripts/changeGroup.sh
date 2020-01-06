#!/bin/bash
username=$(whoami)
echo "enter target user:"
read targetUser
for i in {60..86}
do
	ssh -t $username@166.66.64.$i "sudo usermod -aG wheel $targetUser"
done

