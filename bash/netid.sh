#!/bin/bash

#sourcing the data 
source /etc/os-release

#retrieving name of OS and version
Host=$(hostname)
Distro_Name=$NAME
Distro_Version=$VERSION
# finding external information 
[ "$verbose" = "yes" ] && echo "Checking for external IP address and hostname"
external_address=$(curl -s icanhazip.com)
external_name=$(getent hosts $external_address | awk '{print $2}')

#Checking the available space

Free_Space=$(df -h | grep -w "/" | awk '{print $4}')

cat <<EOF
 
Report for my Host
===============
FQDN: $Host 
Distro name and version: $Distro_Name $Distro_Version
# finding external information 
external_address=$(curl -s icanhazip.com)
external_name=$(getent hosts $external_address | awk '{print $2}')
Root Filesystem Free Space: $Free_Space
===============
EOF

if [ "$myinterfacename" != '' ]; then
	#check the right interface and insert it to variable
		ip addr | grep ${myinterfacename} >/dev/null
		if [ $? -ne 0 ]; then
			echo "interface not exist"
			#find the interface
			interface=$(ip r | grep -w default | awk '{print $5}')
		else
			echo "interface exist"
			interface=$myinterfacename
		fi

fi
interface=$(ip r | grep -w default | awk '{print $5}')


[ "$verbose" = "yes" ] && echo "Reporting on interface(s): $interface"

[ "$verbose" = "yes" ] && echo "Getting IPV4 address and name for interface $interface"
# Find an address and hostname for the interface being summarized
# we are assuming there is only one IPV4 address assigned to this interface
ipv4_address=$(ip a s $interface|awk -F '[/ ]+' '/inet /{print $3}')
ipv4_hostname=$(getent hosts $ipv4_address | awk '{print $2}')

[ "$verbose" = "yes" ] && echo "Getting IPV4 network block info and name for interface $interface"
# Identify the network number for this interface and its name if it has one
# Some organizations have enough networks that it makes sense to name them just like how we name hosts
# To ensure your network numbers have names, add them to your /etc/networks file, one network to a line, as   networkname networknumber
#   e.g. grep -q mynetworknumber /etc/networks || (echo 'mynetworkname mynetworknumber' |sudo tee -a /etc/networks)
network_address=$(ip route list dev $interface scope link|cut -d ' ' -f 1)
network_number=$(cut -d / -f 1 <<<"$network_address")
network_name=$(getent networks $network_number|awk '{print $1}')

cat <<EOF
Interface $interface:
===============
Address         : $ipv4_address
Name            : $ipv4_hostname
Network Address : $network_address
Network Name    : $network_name
EOF


#checking all the interfaces
IPLIST=$(ip -br addr | awk '{print $1}' | grep -v "lo")


#Generating the report for every interface
for interface in $IPLIST; do
		

# Finding an address and hostname for the interface by assuming that we have only one IPV4 address assigned to this interface
	ipv4_address=$(ip a s $interface|awk -F '[/ ]+' '/inet /{print $3}')
	ipv4_hostname=$(getent hosts $ipv4_address | awk '{print $2}')
	

	[ "$verbose" = "yes" ] && echo "Getting IPV4 network block info and name for interface $interface"
# Identify the network number for this interface and its name if it has one
# Adding them to your /etc/networks file, one network to a line, as network name network number to ensure your network numbers have names

	network_address=$(ip route list dev $interface scope link|cut -d ' ' -f 1)
	network_number=$(cut -d / -f 1 <<<"$network_address")
	network_name=$(getent networks $network_number|awk '{print $1}')

cat <<EOF
Interface $interface:
===============
Address         : $ipv4_address
Name            : $ipv4_hostname
Network Address : $network_address
Network Name    : $network_name
EOF
done
#####
# End of per-interface report
#####s
#End
	
