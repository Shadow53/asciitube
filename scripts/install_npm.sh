#!/bin/bash

## Install missing npm for systems with separate packages and nodejs already installed. The nodejs installation also installs npm.
function install_npm(){
	if [ $node = 'true' ] && [ $node_pm = 'false' ] ; then
		echo "npm is required for searching YouTube. If you are running a compatible system I can install it using your system's package manager. Would you like to try this option? [Y/n]"
		read -p ">> " reply
		if [ $reply = 'Y' ] || [ $reply = 'y' ] || [ ! $reply ] ; then
			## Debian-based
			if [ $ID = 'debian' ] || [ $ID = 'ubuntu' ] ; then ## Both use same command
				if [ -f /usr/bin/sudo ] ; then
					if [ $(sudo whoami) = 'root' ] ; then
						sudo apt-get install npm
					else
						if [ $ID = 'debian' ] ; then
							echo "Please enter root password"
							result=$(su -c 'apt-get install npm')
							if [ $result = '1' ] ; then
								install_npm
							fi
						else
							echo "This user does not have sudo privileges. Please install 'libaa1' and restart this script"
							exit 1
						fi
					fi
				else
					echo "Please enter root password"
					result=$(su -c 'apt-get install npm')
					if [ $result = '1' ] ; then
						install_npm
					fi
				fi
				
			## Fedora
			elif  [ $ID = 'fedora' ] ; then
				if [ -f /usr/bin/sudo ] ; then
					if [ $(sudo whoami) = 'root' ] ; then
						sudo yum install npm
					else
						echo "Please enter root password"
						result=$(su -c 'yum install npm')
						if [ $result = '1' ] ; then
							install_npm
						fi
					fi
				else
					echo "Please enter root password"
					result=$(su -c 'yum install npm')
					if [ $result = '1' ] ; then
						install_npm
					fi
				fi
			fi
		elif [ $reply = 'N' ] || [ $reply = 'n' ] ; then
				exit 1
		else
			echo "Invalid input"
			install_mplay
		fi
	fi
}
