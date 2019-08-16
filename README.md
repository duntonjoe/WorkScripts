# WorkScripts
This repo contains various important scripts I've created for system administration purposes.

Linux Scripts

	checkLabStatus.sh:
	-----------------
		This script reports back which machines in the CSCI Linux pool are active on the network. 
		Uptime is important as the machines are mainly used remotely.

	installAcrossLab_yay.sh:
	------------------------
		This script prompts the user for a list of package names, and then begins installing 
		the packages across the CSCI Linux pool. Sadly this install has to be done via manually 
		typing in passwords, as SSH keys are not configured properly

	macAddresses.sh:
	---------------
		I used this script once to grab hostnames and Mac Addresses of machines I was retiring. 
		It was highly useful in that one situation, but honestly I've never used it again.

CSCI366scripts

	DWDSetup.sh:
	------------
		This script was used to automate the configuration of VMs I was deploying. 
		Configuring ~56 lampstacks manually isn't something I wished to do.

	phpErrorLog.sh:
	---------------
		This script went back and fixed php Error loggin in the previously mentioned 
		lampstacks.

Mac Scripts
	
	addLinuxDirToFavs.sh:
	--------------------
		this script mounts the logged in user's partition on our NFS, and then uses mysides 
		to add this mount to the Finder favorites bar.

	edu.millersville.cs.linuxdir.plist:
	----------------------------------
		This poorly named file can be added to the Launch Agents folder in MacOS so that 
		addLinuxDirToFavs.sh runs on user login.
