#!/bin/bash

echo -e "report for myvm"
echo ===============
echo -e "fqdn:\t\t"`hostname --fqdn` #finding fqdn
echo -e `hostnamectl | grep "Operating System"`#finding name and version of OS
echo -e "System Main IP:\t\t"`hostname -I` #finding ip address of device
echo -e "Root Filesystem Free Space:\t\t" `df -h /root` #finding disk space
echo ===============
