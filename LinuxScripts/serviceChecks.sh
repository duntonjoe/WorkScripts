#!/bin/bash
username=$(whoami)
for i in {60..86}
do
	printf "\n"
	echo $(host 166.66.64.$i | cut -d ' ' -f5 | cut -d '.' -f1)
	ssh -t $username@166.66.64.$i "sudo systemctl --failed"
done

