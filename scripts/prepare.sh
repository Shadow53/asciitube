#!/bin/bash

## Get OS info
source /etc/os-release

## Make compatible systems look the same for testing
if [ $ID_LIKE ] && [ $ID != 'ubuntu' ] ; then
	ID=$ID_LIKE
fi
if [ $ID = 'solydxk'] ; then
        ID='debian'
fi
if [ $ID = 'centos' ] ; then
        echo "CentOS is not supported. It may be in the future, but in the meantime you will need to figure out installing dependencies yourself."
        echo "Do you wish to continue? [y/N]"
        read reply
        reply=$(lowercase $reply)
        if [ $reply != 'y' ] ; then
            exit 1
        fi
fi

function check_conflict(){
        if [ $ID = 'debian' ] ; then
                echo "Due to conflicts with a hamradio package's \"node\" binary in Debian, the \"node\" binary from Node.js was renamed from \"node\" to \"nodejs\", subsequently breaking the program for many users."
                echo "I can link the \"nodejs\" binary to \"node\", since most people do not use said hamradio package. Would you like me to continue? [Y/n]"
                read -p ">> " symlink
                symlink=$(lowercase $symlink)
                if [ $symlink = 'y' ] || [ ! $symlink ] ; then
                        if [ -f /usr/bin/sudo ] ; then
                                if [ $(sudo whoami) = 'root' ] ; then
                                        sudo ln -s /usr/bin/nodejs /usr/bin/node
                                else
                                        echo "Please enter root password"
                                        result=$(su -c 'ln -s /usr/bin/nodejs /usr/bin/node')
                                        if [ '$result' = '1' ] ; then
                                                echo "Please execute \"ln -s /usr/bin/nodejs /usr/bin/node\" as root and restart the script."
                                                exit 1
                                        fi
                                fi
                        else
                                echo "Please enter root password"
                                result=$(su -c 'ln -s /usr/bin/nodejs /usr/bin/node')
                                if [ '$result' = '1' ] ; then
                                        echo "Please execute \"ln -s /usr/bin/nodejs /usr/bin/node\" as root and restart the script."
                                        exit 1
                                fi
                        fi
                fi
        fi
        
        
}

## This is distro agnostic and few enough lines to include here
function install_yt_search(){
	if [ $yt_search = 'false' ] ; then
		if [ -f /usr/bin/sudo ] ; then
			if [ $(sudo whoami) = 'root' ] ; then
				sudo npm install ytsearch -g
			else
				echo "Please enter root password"
				result=$(su -c 'npm install ytsearch -g')
				if [ '$result' = '1' ] ; then
					install_yt_search
				fi
			fi
		else
			echo "Please enter root password"
			result=$(su -c 'npm install ytsearch -g')
			if [ '$result' = '1' ] ; then
				install_yt_search
			fi
		fi
	fi
}

function check_deps(){
	## Create folder for use later
	if [ ! -d /tmp/asciitube ] ; then
		mkdir -p /tmp/asciitube
	fi
	
	## Check if the youtube-dl tool is installed
	if [ -f /usr/bin/youtube-dl ] ; then
		yt_dl='system'
		echo "youtube-dl found!"
	elif [ -f /tmp/youtube-ascii/youtube-dl ] ; then
		yt_dl='temp'
		echo "youtube-dl found!"
	else
		echo "WARNING: youtube-dl not found"
		yt_dl='false'
	fi

	## Check for mplayer
	if [ ! -f /usr/bin/mplayer ] ; then
		echo "WARNING: mplayer not found"
		mplay='false'
	else
		echo "mplayer found!"
		mplay='true'
	fi

	## Libraries are in different places in Debian-based distros than others
	if [ $ID = 'debian' ] || [ $ID = 'ubuntu' ] ; then
		## Check for aalib (deb)
		if [ ! -f /usr/lib/x86_64-linux-gnu/libaa.so.1 ] && [ ! -f /usr/lib/i386-linux-gnu/libaa.so.1 ] ; then
			echo "WARNING: aalib not found"
			aalib='false'
		else
			echo "aalib found!"
			aalib='true'
		fi

		## Check for libcaca (deb)
		if [ ! -f /usr/lib/x86_64-linux-gnu/libcaca.so.0 ] && [ ! -f /usr/lib/i386-linux-gnu/libcaca.so.0 ] ; then
			echo "WARNING: libcaca not found"t
			libcaca='false'
		else
			libcaca='true'
			echo "libcaca found!"
		fi
		
	## All other distros
	else
		## Check for aalib
		if [ ! -f /usr/lib/libaa.so.1 ] ; then
			echo "WARNING: aalib not found"
			aalib='false'
		else
			echo "aalib found!"
			aalib='true'
		fi

		## Check for libcaca
		if [ ! -f /usr/lib/libcaca.so.0 ] ; then
			echo "WARNING: libcaca not found"t
			libcaca='false'
		else
			libcaca='true'
			echo "libcaca found!"
		fi
	fi

	## Check for nodejs
	if [ ! -f /usr/bin/nodejs ] && [ ! -f /usr/bin/node ]; then ## binary is called 'nodejs' in Debian and 'node' elsewhere. If using Debian, user can symlink to 'node'
		echo "WARNING: nodejs not found"
		node='false'
	else
		echo "nodejs found!"
		node='true'
	fi

	## Check for npm
	if [ ! -f /usr/bin/npm ] ; then
		echo "WARNING: npm not found"
		node_pm='false'
	else
		echo "npm found!"
		node_pm='true'
	fi

	## Check for ytsearch --- Make sure it is installed along with "inherits"
	if [ ! -f /usr/bin/ytsearch ] ; then
		echo "WARNING: ytsearch not found"
		yt_search='false'
	else
		echo "ytsearch found!"
		yt_search='true'
	fi
}

## Run each install function (function will not run if dependency is installed)

function install_dep(){
	## Source the installation scripts
	source scripts/install_yt_dl.sh
	source scripts/install_mplay.sh
	source scripts/install_aalib.sh
	source scripts/install_libcaca.sh
	source scripts/install_nodejs.sh
	source scripts/install_npm.sh
	
	install_yt_dl
	install_mplay
	install_aalib
	install_libcaca
	install_nodejs
	install_npm
	install_yt_search
	
	check_conflict
}
	
##				AALIB		LIBCACA			MPLAYER			NODEJS			YOUTUBE-DL
## Debian:   	libaa1		libcaca0		mplayer			nodejs/npm ^1	youtube-dl ^2 
## Fedora:		aalib		libcaca			mplayer ^3		nodejs/npm		youtube-dl
## openSUSE:	aalib		libcaca0		mplayer ^4		nodejs			youtube-dl
## Ubuntu:		libaa1		libcaca0		mplayer			nodejs/npm		youtube-dl
## Arch:		aalib		libcaca			mplayer			nodejs			youtube-dl
## Frugalware:	aalib		libcaca			mplayer			nodejs			youtube-dl


## ^1 -- npm is only available in jessie and sid
## ^2 -- requires "deb http://http.debian.net/debian-backports squeeze-backports(-sloppy) main" in /etc/apt/sources.list.d/backports-squeeze.list --- no package for wheezy. Just download to temp directory
## ^3 -- Have to enable RPMFusion using "rpm -Uvh http://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-21.noarch.rpm" and accept gpg key
## ^4 -- Must enable and trust Packman repo: "zypper addrepo -f http://ftp.gwdg.de/pub/linux/packman/suse/openSUSE_13.2/ packman"
