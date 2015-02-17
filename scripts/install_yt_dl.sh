#!/bin/bash

## Function for downloading youtube-dl
function dl_youtube(){
	wget -c 'https://yt-dl.org/downloads/2015.02.11/youtube-dl' -P /tmp/youtube-ascii/
	chmod +x /tmp/youtube-ascii/youtube-dl
}

## Install missing youtube-dl
function install_yt_dl(){
	if [ $yt_dl = 'false' ] ; then
		echo "youtube-dl is required to download YouTube videos. If you are running a compatible system I can install it using your system's package manager. If not, or if you don't want to do that, I can download it to its own directory in /tmp/asciitube. Would you like to try using the package manager? [Y/n]"
		read reply
		if [ $reply = 'Y' ] || [ $reply = 'y' ] || [ ! $reply ] ; then
			## Debian-based
			if [ $ID = 'debian' ] || [ $ID = 'ubuntu' ] ; then ## Both use same command
				if [ -f /usr/bin/sudo ] ; then
					if [ $(sudo whoami) = 'root' ] ; then
						sudo apt-get install youtube-dl
					else
						if [ $ID = 'debian' ] ; then
							echo "Please enter root password"
							result=$(su -c 'apt-get install youtube-dl')
							if [ $result = '1' ] ; then
								install_yt_dl
							fi
						else
							echo "This user does not have sudo privileges. Please install 'youtube-dl' and restart this script"
							exit 1
						fi
					fi
				else
					echo "Please enter root password"
					result=$(su -c 'apt-get install youtube-dl')
					if [ $result = '1' ] ; then
						install_yt_dl
					fi
				fi
				
			## Fedora
			elif [ $ID = 'fedora' ] ; then
				if [ -f /usr/bin/sudo ] ; then
					if [ $(sudo whoami) = 'root' ] ; then
						sudo yum install youtube-dl
					else
						echo "Please enter root password"
						result=$(su -c 'yum install youtube-dl')
						if [ $result = '1' ] ; then
							install_yt_dl
						fi
					fi
				else
					echo "Please enter root password"
					result=$(su -c 'yum install youtube-dl')
					if [ $result = '1' ] ; then
						install_yt_dl
					fi
				fi
			
			## openSUSE
			elif [ $ID = 'opensuse' ] ; then
				if [ -f /usr/bin/sudo ] ; then
					if [ $(sudo whoami) = 'root' ] ; then
						sudo zypper in youtube-dl
					else
						echo "Please enter root password"
						result=$(su -c 'zypper in youtube-dl')
						if [ $result = '1' ] ; then
							install_yt_dl
						fi
					fi
				else
					echo "Please enter root password"
					result=$(su -c 'zypper in youtube-dl')
					if [ $result = '1' ] ; then
						install_yt_dl
					fi
				fi
			
			## Arch Linux and Frugalware -- Both use pacman and same name style
			elif [ $ID = 'arch' ] || [ $ID = 'frugalware' ]; then
				if [ -f /usr/bin/sudo ] ; then
					if [ $(sudo whoami) = 'root' ] ; then
						sudo pacman -Sy youtube-dl
					else
						echo "Please enter root password"
						result=$(su -c 'pacman -Sy youtube-dl')
						if [ $result = '1' ] ; then
							install_yt_dl
						fi
					fi
				else
					echo "Please enter root password"
					result=$(su -c 'pacman -Sy youtube-dl')
					if [ $result = '1' ] ; then
						install_yt_dl
					fi
				fi
			else
				echo "Would you like to install to /tmp/asciitube? [Y/n]"
				read reply
				if [ $reply = 'Y' ] || [ $reply = 'y' ] ; then
					dl_youtube
				elif [ $reply = 'N' ] || [ $reply = 'n' ] ; then
					exit 1
				else
					echo "Invalid input"
					install_yt_dl
				fi
			fi
		elif [ $reply = 'N' ] || [ $reply = 'n' ] ; then
			echo "Would you like to install to /tmp/asciitube? [Y/n]"
			read reply
			if [ $reply = 'Y' ] || [ $reply = 'y' ] ; then
				dl_youtube
			elif [ $reply = 'N' ] || [ $reply = 'n' ] ; then
				exit 1
			else
				echo "Invalid input"
				install_yt_dl
			fi
		else
			echo "Invalid input"
			install_yt_dl
		fi
	fi
}
