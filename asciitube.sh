#!/bin/bash
## Clears terminal so that it looks nice
clear

## ASCII Art, just cuz
cat << "EOF"
########################################################################################
########################################################################################
####            ___           ___           ___                                     ####
####           /  /\         /  /\         /  /\        ___         ___             ####
####          /  /::\       /  /:/_       /  /:/       /  /\       /  /\            ####
####         /  /:/\:\     /  /:/ /\     /  /:/       /  /:/      /  /:/            ####
####        /  /:/~/::\   /  /:/ /::\   /  /:/  ___  /__/::\     /__/::\            ####
####       /__/:/ /:/\:\ /__/:/ /:/\:\ /__/:/  /  /\ \__\/\:\__  \__\/\:\__         ####
####       \  \:\/:/__\/ \  \:\/:/~/:/ \  \:\ /  /:/    \  \:\/\    \  \:\/\        ####
####        \  \::/       \  \::/ /:/   \  \:\  /:/      \__\::/     \__\::/        ####
####         \  \:\        \__\/ /:/     \  \:\/:/       /__/:/      /__/:/         ####
####          \  \:\         /__/:/       \  \::/        \__\/       \__\/          ####
####           \__\/         \__\/         \__\/                                    ####
####                              ___                         ___                   ####
####                  ___        /__/\         _____         /  /\                  ####
####                 /  /\       \  \:\       /  /::\       /  /:/_                 ####
####                /  /:/        \  \:\     /  /:/\:\     /  /:/ /\                ####
####               /  /:/     ___  \  \:\   /  /:/~/::\   /  /:/ /:/_               ####
####              /  /::\    /__/\  \__\:\ /__/:/ /:/\:| /__/:/ /:/ /\              ####
####             /__/:/\:\   \  \:\ /  /:/ \  \:\/:/~/:/ \  \:\/:/ /:/              ####
####             \__\/  \:\   \  \:\  /:/   \  \::/ /:/   \  \::/ /:/               ####
####                  \  \:\   \  \:\/:/     \  \:\/:/     \  \:\/:/                ####
####                   \__\/    \  \::/       \  \::/       \  \::/                 ####
####                             \__\/         \__\/         \__\/                  ####
########################################################################################
########################################################################################

EOF

function dl_youtube-dl(){
	wget -c https://yt-dl.org/downloads/2015.02.11/youtube-dl -P /tmp/youtube-ascii/
	chmod +x /tmp/youtube-ascii/youtube-dl
}
function prepare(){
	## Create temporary folder for use later
	mkdir -p /tmp/youtube-ascii

	## Check if the youtube-dl tool is installed
	if [ -f /usr/bin/youtube-dl ] ;
	then
		yt_dl='system'
		echo "youtube-dl found!"
	elif [ -f /tmp/youtube-ascii/youtube-dl ] ;
	then
		yt_dl='temp'
		echo "youtube-dl found!"
	else
		echo "youtube-dl not found. Continue and download the program for use with this script? Select [n] ; to install using your package manager [Y/n] ;"
		read -p '>> ' ydl_cont
		if [ $ydl_cont ] ;
		then
			if [ $ydl_cont = 'Y' ] || [ $ydl_cont = 'y' ] ;
			then
				dl_youtube-dl
			elif [ $ydl_cont = 'N' ] || [ $ydl_cont = 'n' ] ;
			then
				exit 1
			fi
		else
			dl_youtube-dl
		fi    
	fi

	## Check for mplayer
	if [ ! -f /usr/bin/mplayer ] ;
	then
		echo "mplayer not found. Please install it and run this program again."
		exit 1
	else
		echo "mplayer found!"
	fi

	## Check for aalib
	## AALIB CHECK FAILS ON UBUNTU, library is installed but the programs (like aainfo) are not
	if [ ! -f /usr/bin/aainfo ] ;
	then
		echo "aalib not found. This is required for black and white playback. If you plan on using color output you can continue, otherwise you should install 'aalib' using your system's package manager. Continue? [y/N] ;"
		read -p '>> ' aalib_cont
		if [ $aalib_cont ] ;
		then
			if [ $aalib_cont = 'Y' ] || [ $aalib_cont = 'y' ] ;
			then
				aalib=false
				## Continue
			elif [ $aalib_cont = 'N' ] || [ $aalib_cont = 'n' ] ;
			then
				exit 1
			fi
		else
			exit 1
		fi
	else
		aalib=true
		echo "aalib found!"
	fi

	## Check for libcaca
	caca_exists=$(pkg-config --exists libcaca)
	if [ caca_exists = '1' ] ;
	then
		if [ $aalib = true ] ;
		echo "libcaca not found. This is required for color playback. If you plan on using black output you can continue, otherwise you should install 'aalib' using your system's package manager. Continue? [y/N] ;"
		read -p '>> ' libcaca_cont
		then
			if [ $libcaca_cont ] ;
			then
				if [ $libcaca_cont = 'Y' ] || [ $libcaca_cont = 'y' ] ;
				then
					libcaca=false
					## Continue
				elif [ $libcaca_cont = 'N' ] || [ $libcaca_cont = 'n' ] ;
				then
					exit 1
				fi
			else
				exit 1
			fi
		elif [ $aalib = false ] ;
		then
			echo "No playback libraries found. Please install aalib and/or libcaca through your package manager then restart this script."
		fi
	else
		libcaca=true
		echo "libcaca found!"
	fi
}

##### YouTube Search Tool - get URL #####

function search(){
	i=1
	until [ $i = $num_results ]
	do
		j=$(($i+$offset))
		ytsearch "$query" -f "$j) %t -- %a \n %u\n\n" -o $j -v
		i=$(($i+1))
	done
	
	echo "Enter the number for the video you want, [Enter] to continue searching, or type a new search."
	read search_input

	if [ ! $search_input ] ;
	then
		offset=$(($offset+$num_results))
		search
	else
		if [[ $((search_input+0)) != 0 ]]
		then
			url="$(ytsearch "$query" -f "%u" -o "$search_input")"
		else
			query=$search_input
			offset=0
			search
		fi
	fi
}

function first_search(){
	echo -e "\nSearch for video:"
	read query
	offset=0
	let num_results=$(($(tput lines)/3))
	search
}

#####

## Get video URL for playback
#echo $'\nPlease enter the URL of the youtube video you want to watch, starting with "http:" or "https:"\n(For test usage type "asdf")' ## $' interprets \n as a new line
#read -p '>> ' url

## Hidden thing to easily enter url when showing it off
#if [ $url = 'asdf' ] ;
#then
#    url='https://www.youtube.com/watch?v=IYnsfV5N2n8'
#elif [ $url = 'skyrim' ] ;
#then
#    url='https://www.youtube.com/watch?v=BSLPH9d-jsI'
#fi

function dl_vid(){
	## Get string length of the URL
	size=${#url}
	echo "URL = $url"

	## HTTPS has one more character in the URL to HTTP, so test which one and remove all but the video ID
	id=${url:17:$size}

	## Use the youtube-dl tool to download the file to the temporary directory
	if [ $yt_dl = 'system' ] ;
	then
		youtube-dl -o /tmp/youtube-ascii/$id $url
	elif [ $yt_dl = 'temp' ] ;
	then
		/tmp/youtube-ascii/youtube-dl -o /tmp/youtube-ascii/$id $url
	fi
}


function color_pick(){
	## Get preference of color or black and white based on which libraries are installed

	if [ $aalib = true ] ; ## If aalib is installed
	then
		if [ $libcaca = true ] ; ## If libcaca is also installed
		then
			## Check which library they want to use
			echo $'\nWould you like to have black and white [B] ; or basic color [C] ; output? (Default: B)' ## $' interprets \n as a new line
			read -p '>> ' color

			## Test first for empty string (default) then for black and white or color
			if [ $color ] ;
			then
				if [ $color = 'B' ] || [ $color = 'b' ] ;
				then
					color='black'
				elif [ $color = 'C' ] || [ $color = 'c' ] ;
				then
					color='color'
				else
					echo "Unknown option. Please enter \"B\" for black and white or \"C\" for color output. (Default: B)"
					read -p '>> ' color
						if [ $color = 'B' ] || [ $color = 'b' ] ;
						then
							color='black'
						elif [ $color = 'C' ] || [ $color = 'c' ] ;
						then
							color='color'
						else
							echo "Bad input. Exiting."
							exit 1
						fi
				fi
			else
				color='black'
			fi
		elif [ $libcaca = false ] ; ## If libcaca is not installed but aalib is
		then
			## Check if aalib is okay
			echo $'\nIs black and white output okay? [Y/n] ;' ## $' interprets \n as a new line
			read -p '>> ' color

			## Test first for empty string (default) then for black and white or exiting
			if [ $color ] ;
			then
				if [ $color = 'Y' ] || [ $color = 'y' ] ;
				then
					color='black'
				elif [ $color = 'N' ] || [ $color = 'n' ] ;
				then
					echo "libcaca is not installed so color output is not possible. Install it using your system's package manager."
					echo "Exiting."
					exit 1
				else
					echo "Unknown option. Please enter \"Y\" to use black and white or \"n\" to exit. (Default: Y)"
					read -p '>> ' color
						if [ $color = 'Y' ] || [ $color = 'y' ] ;
						then
							color='black'
						elif [ $color = 'N' ] || [ $color = 'n' ] ;
						then
							echo "Exiting"
							exit 1
						else
							echo "Bad input. Exiting."
							exit 1
						fi
				fi
			else
				color='black'
			fi
		fi
	elif [ $aalib = false ] ; ## If aalib is NOT installed
	then
		if [ $libcaca = true ] ; ## If libcaca is installed
		then
			## Check if libcaca is okay
			echo "Is color output okay? [Y/n] ;"
			read -p '>> ' color

			## Test first for empty string (default) then for color or exiting
			if [ $color ] ;
			then
				if [ $color = 'Y' ] || [ $color = 'y' ] ;
				then
					color='color'
				elif [ $color = 'N' ] || [ $color = 'n' ] ;
				then
					echo "aalib is not installed so black and white output is not possible. Install it using your system's package manager."
					echo "Exiting."
					exit 1
				else
					echo "Unknown option. Please enter \"Y\" to use color or \"n\" to exit. (Default: Y)"
					read -p '>> ' color
						if [ $color = 'Y' ] || [ $color = 'y' ] ;
						then
							color='color'
						elif [ $color = 'N' ] || [ $color = 'n' ] ;
						then
							echo "Exiting"
							exit 1
						else
							echo "Bad input. Exiting."
							exit 1
						fi
				fi
			else
				color='color'
			fi
		elif [ $libcaca = false ] ; ## If somehow they got this far without either library
		then
			echo "Somehow you got this far without having either library installed. When this program exits, please install either aalib, libcaca, or both using your system's package manager."
			exit 1
		fi
	else ## This should never actually happen
		echo "I don't know how this happened. Exiting."
		exit 1
	fi
}


function play_vid(){
	## Do they want to be reminded/informed of the mplayer controls?
	echo $'\nMPlayer uses certain keys to play/pause and seek videos in the terminal.\nWould you like to be reminded of what they are? [Y/n] ;' ## $' interprets \n as a new line
	read -p '>> ' remind
	## Test first for empty string (default) then for black and white or color
	if [ $remind ] ;
	then
		if [ $remind = 'N' ] || [ $remind = 'n' ] ;
		then
			remind='N' ## Needs code here to continue
		else
		   echo 'Play/Pause     =>   Space or p'
		   echo 'Seek forward   =>  Right arrow'
		   echo 'Seek backward  =>   Left arrow'
		   echo 'Quit           =>            q'
		   echo $'\nPress enter to continue' ## $' interprets \n as a new line
		   read -p '>> '
		fi
	else
		echo 'Play/Pause     =>   Space or p'
		echo 'Seek forward   =>  Right arrow'
		echo 'Seek backward  =>   Left arrow'
		echo 'Quit           =>            q'
		echo $'\nPress enter to continue' ## $' interprets \n as a new line
		read -p '>> '
	fi
			
	## Actually play the video!
	if [ $color = 'black' ] ;
	then
		mplayer -vo aa:driver=curses -quiet -monitorpixelaspect 0.5 -x 1366 -y 768 /tmp/youtube-ascii/$id
	elif [ $color = 'color' ] ;
	then
		CACADRIVER=ncurses
		mplayer -vo caca -quiet -x 1366 -y 768 /tmp/youtube-ascii/$id
	else
		echo "Something went wrong. Exiting."
	fi
	
	asciiTube
}

function asciiTube(){
	first_search
	dl_vid
	color_pick
	play_vid
	clear
}

######################################################################
##                                                                  ##
##                    RUN THE ACTUAL PROGRAM HERE                   ##
##                                                                  ##
######################################################################

prepare
asciiTube

echo "Thanks for watching!"
