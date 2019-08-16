#Author:	Joe Dunton
#Desc:		This script automatically adds the logged in user's NFS 
#		partition to the finder favorites bar.
#!/user/bin/env bash

user=$(whoami)

case "$(groups ${user})" in

    *CSStudents* ) group="students" ;;

    *CSStaff*    ) group="staff" ;;

    *            ) group="faculty" ;;

esac

if [ "$(/usr/local/bin/mysides list | grep -c "^${USER}")" -eq 0 ]
then
	/usr/local/bin/mysides add ${user} file:///Volumes/csfiles/${group}/${user} 
fi
