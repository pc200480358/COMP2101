#! /bin/bash
#going to the bash directory 
echo "FQDN: " $(hostname --fqdn)
#showing fqdn details
hostname -f
#showing hostnam details
hostnamectl
#hosname changes
echo "IP Addresses: "$(hostname -I)
#showing ip address
echo ""
#showing storage info for root
echo "Root system info: "
echo $(df -h | sed -n 1p)
echo $(df -h | sed -n 3p)
