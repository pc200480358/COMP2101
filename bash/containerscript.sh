#!/bin/bash

#use the which command to see if lxd exists on the system already

which lxd > /dev/null

if [ $? -ne 0 ]; then
#need to install lxd
	echo "Installing lxd - you may need to input password"
	sudo snap install lxd
	if [ $? -ne 0 ]; then
	#failed to install lxd - exit with error message and status
	echo "Failed to install lxd"
	exit 1
	fi
fi

#lxd software install complete


#check to see if lxdbr0 interface exists using "ip link show"

ip link show | grep -w "lxdbr0" > /dev/null

#if not, need to run lxd init --auto

if [ $? -ne 0 ]; then
	echo "Interface lxdbr0 does not exist - creating it now"
	lxd init --auto
	if [ $? -ne 0 ]; then
		echo "Initialization failed"
		exit 1
	fi
else
	echo "lxdbr0 already exists on this machine."
	
fi
#collect IP address
Container_IP=$(lxc info COMP2101-F22 | grep -w inet | grep -w global |awk '{print $2}' | cut -f1 -d "/")

#see if the container exist?  move to /dev/null without showing output

lxc list | grep -w "COMP2101-S22 | RUNNING" > /dev/null

#create and launch container

if [ $? -ne 0 ]; then
	echo "Launching Ubuntu container and naming it COMP2101-S22"
	lxc launch ubuntu:20.04 COMP2101-S22
	if [ $? -ne 0 ]; then
		echo "Failed to launch container."
		exit 1
	fi

fi

#time to collect information
sleep 5

  
if [ $? -ne 0 ]; then
	echo "IP not detected, creating an entry. Sudo permissions may be required."
	sudo sed -i "3i$IpAndHostname" /etc/hosts
	if [ $? -ne 0 ]; then
		echo "Failed to add to /etc/hosts"
		exit 1
	fi
else
	echo "IP and Hostname already exist ."
fi


#see if Apache2 exist in the container?  redirect to /dev/null without showing output

lxc exec COMP2101-S22 -- which apache2 > /dev/null

# install if Apache2 does not exist in container

if [ $? -ne 0 ]; then
	echo "installing Apache2"
	lxc exec COMP2101-S22 -- apt install apache2
	if [ $? -ne 0 ]; then
	echo "Failed to install Apache2"
	exit 1
	fi
else
	echo "Apache2 installed."
	
fi


# see if curl is installed

which curl > /dev/null

#if it's not installed, install curl

if [ $? -ne 0 ]; then
	echo "Installing curl. Sudo permissions may be required."
	sudo snap install curl
	if [ $? -ne 0 ]; then
		echo "Failed to install curl."
		exit 1
	fi
fi

#retrieve the default web page from Apache

curl http://COMP2101-S22 > /dev/null


if [ $? -ne 0 ]; then
	echo "unable to connect to WebServer"
	exit 1
else
	echo "Web page retrieved"
	
fi
