#!/bin/bash
username=$(whoami)
for i in {60..86}
do
	ssh -t $username@166.66.64.$i 'sudo usermod -aG wheel tjmichae'
done

