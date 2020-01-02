#!/bin/bash
username=$(whoami)
echo -n "Enter space delimited package list and press [ENTER]: "
read packages
for i in {60..86}
do
	ssh -t $username@166.66.64.$i "sudo pip install $packages"
done

