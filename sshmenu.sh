#!/bin/bash

#This is quit little program to present the console user with a list of ssh connections
#Useful for system admins who frequently shell into various systems.  I suggest giving 
#the remote ends your id_dsa.pub or id_rsa.pub if you are working in a trusted environment
#for ease of access.  I personally make this script part of my .bashrc.

#Written by Ian Langdon (ianlangdon.ca @geeksedition ).  Do what you want with this.  
#Just give credit where credit is due by preserving this comment block.  Thanks, and Enjoy


#User Variables, YOU change these to your needs.
SHOW_HEADER=1				# Do you want a custom message at the top?
CLEAR_SCREEN=1				# 1 to clear screen
MENU_HEADER_FILE="/home/ilangdon/bin/sshMenu/ServerListInfo"	# Text file with menu header
SERVER_LIST_FILE="/home/ilangdon/bin/sshMenu/ServerList"		# File with Server List

VERSION="1.1"


#Version 1.0 - Initial Build
#Version 1.1 - Added port ability

#Modification below is not required unless you are going to tinker under the hood.  ;)_

#_____[ This is the hood ;) ]________________________________________________________________
ENTRIES=0
COUNTER=0
COMMAND=-1


#Clear the screen if configured.
[[ $CLEAR_SCREEN -gt 0 ]] && clear


#Display the Header.... duh
[[ $SHOW_HEADER -gt 0 ]] && cat $MENU_HEADER_FILE
	
#Read the Server list into arrays
while IFS=: read NAME USER SERVER PORT
do
	#Lets Skip Comments
	[[ $NAME = \#* ]] && continue
	#and skip blank lines
	[[ $NAME = "" ]] && continue
	let ENTRIES=ENTRIES+1
	SERVERNAMES[$ENTRIES]="$NAME"
	USERNAMES[$ENTRIES]="$USER"
	SERVER_ADDRESSES[$ENTRIES]="$SERVER"
	if [[ $PORT = "" ]]; then
		SERVER_PORT[$ENTRIES]="22"
	else
		SERVER_PORT[$ENTRIES]="$PORT"
	fi
done < "$SERVER_LIST_FILE" 
	
	
#Start control: Begin Program loop
while [ $COMMAND -ne "0" ]
do

	#Display the Menu
	echo -e "\tCommand\t\tServer"
	echo -e "\t-------\t\t------"
	COUNTER=1
	while [ $COUNTER -le $ENTRIES ]; do
		echo -e "\t$COUNTER\t\t${SERVERNAMES[$COUNTER]} (ssh ${USERNAMES[$COUNTER]}@${SERVER_ADDRESSES[$COUNTER]})"
		let COUNTER=COUNTER+1
	done
	echo ""
	echo -e "\t0\t\tExit"
	echo ""
	echo -e "Enter command:"
	
	#Read the command from user
	read COMMAND

	#If we get a 0, then SCRAM with a nice pretty exit code of 0
	if [[ $COMMAND -eq "0" ]]; then
		exit 1
	fi
	
	if [ $COMMAND -le $ENTRIES ]; then
		
		#Test to see if the user gives a sane entry.
		if [ $COMMAND -le $ENTRIES ]; then
			#ENTER EXECUTION CODE IN HERE
			ssh -p ${SERVER_PORT[$COMMAND]} ${USERNAMES[$COMMAND]}@${SERVER_ADDRESSES[$COMMAND]}
		else
			#ENTER FAIL MESSAGE IN HERE
			echo "FAIL!"
		fi
	else
		continue
	fi
done
	
