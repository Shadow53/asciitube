#!/bin/bash

## Install missing libcaca
function install_libcaca(){
	if [ $libcaca = 'false' ] ; then
		echo "libcaca is required for color playback. If you are running a compatible system I can install it using your system's package manager. Would you like to try this option? [Y/n]"
		read -p ">> " reply
		if [ $reply = 'Y' ] || [ $reply = 'y' ] || [ ! $reply ] ; then
			## Debian-based
			if [ $ID = 'debian' ] || [ $ID = 'ubuntu' ] ; then ## Both use same command
				if [ -f /usr/bin/sudo ] ; then
					if [ $(sudo whoami) = 'root' ] ; then
						sudo apt-get install libcaca0
					else
						if [ $ID = 'debian' ] ; then
							echo "Please enter root password"
							result=$(su -c 'apt-get install libcaca0')
							if [ $result = '1' ] ; then
								install_libcaca
							fi
						else
							echo "This user does not have sudo privileges. Please install 'libaa1' and restart this script"
							exit 1
						fi
					fi
				else
					echo "Please enter root password"
					result=$(su -c 'apt-get install libcaca0')
					if [ $result = '1' ] ; then
						install_libcaca
					fi
				fi
				
			## Fedora
			elif [ $ID = 'fedora' ] ; then
				if [ -f /usr/bin/sudo ] ; then
					if [ $(sudo whoami) = 'root' ] ; then
						sudo yum install libcaca
					else
						echo "Please enter root password"
						result=$(su -c 'yum install libcaca')
						if [ $result = '1' ] ; then
							install_libcaca
						fi
					fi
				else
					echo "Please enter root password"
					result=$(su -c 'yum install libcaca')
					if [ $result = '1' ] ; then
						install_libcaca
					fi
				fi
			
			## openSUSE
			elif [ $ID = 'opensuse' ] ; then
				if [ -f /usr/bin/sudo ] ; then
					if [ $(sudo whoami) = 'root' ] ; then
						sudo zypper in libcaca
					else
						echo "Please enter root password"
						result=$(su -c 'zypper in libcaca')
						if [ $result = '1' ] ; then
							install_libcaca
						fi
					fi
				else
					echo "Please enter root password"
					result=$(su -c 'zypper in libcaca')
					if [ $result = '1' ] ; then
						install_libcaca
					fi
				fi
			## Arch Linux and Frugalware -- Both use pacman and same name style
			elif [ $ID = 'arch' ] || [ $ID = 'frugalware' ]; then
				if [ -f /usr/bin/sudo ] ; then
					if [ $(sudo whoami) = 'root' ] ; then
						sudo pacman -Sy libcaca
					else
						echo "Please enter root password"
						result=$(su -c 'pacman -Sy libcaca')
						if [ $result = '1' ] ; then
							install_libcaca
						fi
					fi
				else
					echo "Please enter root password"
					result=$(su -c 'pacman -Sy libcaca')
					if [ $result = '1' ] ; then
						install_libcaca
					fi
				fi
			
			else
				echo "Your distribution is not supported yet. Please install libcaca for your distribution and restart this script."
			fi
		elif [ $reply = 'N' ] || [ $reply = 'n' ] ; then
				exit 1
		else
			echo "Invalid input"
			install_mplay
		fi
	fi
}
