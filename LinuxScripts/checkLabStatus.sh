#Author:	Joe Dunton
#Desc:		This script shows which machines are active or 
#		inactive in the lab
#!/bin/bash
machines=()
for i in {60..86}
do
	current_machine=$(host 166.66.64.$i | cut -d ' ' -f 5 | cut -d '.' -f 1)
	machines+=( $current_machine )
done
for host in ${machines[@]}
do
	ping -c 1 "$host" > /dev/null
    	if [ $? -eq 0 ] 
	then
    		tput setaf 2;
		echo "$host is up" 
    	else
		tput setaf 1;
    		echo "$host is down"
   	fi
done
tput sgr0
