#!/bin/bash

echo -e "report for myvm"
echo ===============
echo -e "fqdn:\t\t"`hostname --fqdn`
echo -e `hostnamectl | grep "Operating System"`
echo -e "System Main IP:\t\t"`hostname -I`
echo -e "Root Filesystem Free Space:\t\t" `df -h /root`
echo ===============
