## Install missing mplayer
function install_mplay(){
	if [ $mplay = 'false' ] ; then
		echo "mplayer is required. If you are running a compatible system I can install it using your system's package manager. Would you like to try this option? [Y/n]"
		read -p ">> " reply
		if [ $reply = 'Y' ] || [ $reply = 'y' ] || [ ! $reply ] ; then
			## Debian-based
			if [ $ID = 'debian' ] || [ $ID = 'ubuntu' ] ; then ## Both use same command
				if [ -f /usr/bin/sudo ] ; then
					if [ $(sudo whoami) = 'root' ] ; then
						sudo apt-get install mplayer
					else
						if [ $ID = 'debian' ] ; then
							echo "Please enter root password"
							result=$(su -c 'apt-get install mplayer')
							if [ $result = '1' ] ; then
								install_mplay
							fi
						else
							echo "This user does not have sudo privileges. Please install mplayer and restart this script"
							exit 1
						fi
					fi
				else
					echo "Please enter root password"
					result=$(su -c 'apt-get install mplayer')
					if [ $result = '1' ] ; then
						install_mplay
					fi
				fi
				
			## Fedora
			elif [ $ID = 'fedora' ] ; then
				echo "You appear to be running Fedora. The RPM Fusion repository must be enabled to install mplayer. Is this okay?"
				read result
				if [ $result = 'Y' ] || [ $result = 'y' ] ; then
					if [ -f /usr/bin/sudo ] ; then
						if [ $(sudo whoami) = 'root' ] ; then
							sudo rpm -Uvh http://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-21.noarch.rpm
							sudo yum install mplayer
						else
							echo "Please enter root password"
							result=$(su -c 'rpm -Uvh http://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-21.noarch.rpm && yum install mplayer')
							if [ $result = '1' ] ; then
								install_mplay
							fi
						fi
					else
						echo "Please enter root password"
						result=$(su -c 'rpm -Uvh http://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-21.noarch.rpm && yum install mplayer')
						if [ $result = '1' ] ; then
							install_mplay
						fi
					fi
				elif [ $result = 'N' ] || [ $result = 'n' ] ; then
					exit 1
				else
					install_mplay
				fi
			
			## openSUSE
			elif [ $ID = 'opensuse' ] ; then
				echo "You appear to be running openSUSE. The Packman repository must be enabled to install mplayer. Is this okay?"
				read result
				if [ $result = 'Y' ] || [ $result = 'y' ] ; then
					if [ -f /usr/bin/sudo ] ; then
						if [ $(sudo whoami) = 'root' ] ; then
							sudo zypper addrepo -f http://ftp.gwdg.de/pub/linux/packman/suse/openSUSE_13.2/ packman
							sudo zypper in mplayer
						else
							echo "Please enter root password"
							result=$(su -c 'zypper addrepo -f http://ftp.gwdg.de/pub/linux/packman/suse/openSUSE_13.2/ packman && zypper in mplayer')
							if [ $result = '1' ] ; then
								install_mplay
							fi
						fi
					else
						echo "Please enter root password"
						result=$(su -c 'zypper addrepo -f http://ftp.gwdg.de/pub/linux/packman/suse/openSUSE_13.2/ packman && zypper in mplayer')
						if [ $result = '1' ] ; then
							install_mplay
						fi
					fi
				elif [ $result = 'N' ] || [ $result = 'n' ] ; then
					exit 1
				else
					install_mplay
				fi
			## Arch Linux
			elif [ $ID = 'arch' ] || [ $ID = 'frugalware' ] ; then
				if [ -f /usr/bin/sudo ] ; then
					if [ $(sudo whoami) = 'root' ] ; then
						sudo pacman -Sy mplayer
					else
						echo "Please enter root password"
						result=$(su -c 'pacman -Sy mplayer')
						if [ '$result' = '1' ] ; then
							install_mplay
						fi
					fi
				else
					echo "Please enter root password"
					result=$(su -c 'pacman -Sy mplayer')
					if [ '$result' = '1' ] ; then
						install_mplay
					fi
				fi
			else
				echo "Your distribution is not supported yet. Please install mplayer for your distribution and restart this script."
			fi
		elif [ $reply = 'N' ] || [ $reply = 'n' ] ; then
				exit 1
		else
			echo "Invalid input"
			install_mplay
		fi		
	fi
}
