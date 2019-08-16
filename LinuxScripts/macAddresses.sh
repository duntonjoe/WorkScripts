#Author:	Joe Dunton
#Desc:		send hostname and mac address via email to me
#!/bin/bash
$email = "target@example.com"
cat /etc/hostname > address.txt

#isolates mac address of eth0 adapter
ip link show dev eth0 | sed -nre 's@.*link\/ether (\S+).*@\1@p' >> address.txt
mail -s "$HOSTNAME" $email < address.txt
rm address.txt
