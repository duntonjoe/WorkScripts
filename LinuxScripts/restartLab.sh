#!/bin/bash
username=$(whoami)
for i in {61..86}
do
	ssh -t $username@166.66.64.$i "sudo reboot now"
done

