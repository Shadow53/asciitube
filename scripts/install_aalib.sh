#!/bin/bash

## Install missing aalib
function install_aalib(){
	if [ $aalib = 'false' ] ; then
		echo "aalib is required for black and white playback. If you are running a compatible system I can install it using your system's package manager. Would you like to try this option? [Y/n]"
		read -p ">> " reply
		if [ $reply = 'Y' ] || [ $reply = 'y' ] || [ ! $reply ] ; then
			## Debian-based
			if [ $ID = 'debian' ] || [ $ID = 'ubuntu' ] ; then ## Both use same command
				if [ -f /usr/bin/sudo ] ; then
					if [ $(sudo whoami) = 'root' ] ; then
						sudo apt-get install libaa1
					else
						if [ $ID = 'debian' ] ; then
							echo "Please enter root password"
							result=$(su -c 'apt-get install libaa1')
							if [ $result = '1' ] ; then
								install_aalib
							fi
						else
							echo "This user does not have sudo privileges. Please install 'libaa1' and restart this script"
							exit 1
						fi
					fi
				else
					echo "Please enter root password"
					result=$(su -c 'apt-get install libaa1')
					if [ $result = '1' ] ; then
						install_aalib
					fi
				fi
				
			## Fedora
			elif [ $ID = 'fedora' ] ; then
				if [ -f /usr/bin/sudo ] ; then
					if [ $(sudo whoami) = 'root' ] ; then
						sudo yum install aalib
					else
						echo "Please enter root password"
						result=$(su -c 'yum install aalib')
						if [ $result = '1' ] ; then
							install_aalib
						fi
					fi
				else
					echo "Please enter root password"
					result=$(su -c 'yum install aalib')
					if [ $result = '1' ] ; then
						install_aalib
					fi
				fi

			## openSUSE
			elif [ $ID = 'opensuse' ] ; then
				if [ -f /usr/bin/sudo ] ; then
					if [ $(sudo whoami) = 'root' ] ; then
						sudo zypper in aalib
					else
						echo "Please enter root password"
						result=$(su -c 'zypper in aalib')
						if [ $result = '1' ] ; then
							install_aalib
						fi
					fi
				else
					echo "Please enter root password"
					result=$(su -c 'zypper in aalib')
					if [ $result = '1' ] ; then
						install_aalib
					fi
				fi
			## Arch Linux and Frugalware -- Both use pacman and same name style
			elif [ $ID = 'arch' ] || [ $ID = 'frugalware' ]; then
				if [ -f /usr/bin/sudo ] ; then
					if [ $(sudo whoami) = 'root' ] ; then
						sudo pacman -Sy aalib
					else
						echo "Please enter root password"
						result=$(su -c 'pacman -S aalib')
						if [ $result = '1' ] ; then
							install_aalib
						fi
					fi
				else
					echo "Please enter root password"
					result=$(su -c 'pacman -S aalib')
					if [ $result = '1' ] ; then
						install_aalib
					fi
				fi

			else
				echo "Your distribution is not supported yet. Please install aalib for your distribution and restart this script."
				exit 1
			fi
			
		elif [ $reply = 'N' ] || [ $reply = 'n' ] ; then
				exit 1
		else
			echo "Invalid input"
			install_mplay
		fi
	fi
}
