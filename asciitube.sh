#!/bin/bash
function prepare(){
	source scripts/prepare.sh
	check_deps
	install_dep
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
	read -p '>> ' search_input

	if [ ! $search_input ] ; then
		offset=$(($offset+$num_results))
		search
	else
		if [[ $((search_input+0)) != 0 ]] ; then
			url="$(ytsearch "$query" -f "%u" -o "$search_input")"
		else
			query='$search_input'
			offset=0
			search
		fi
	fi
}

function first_search(){
	echo -e "\nWhat would you like to watch?"
	read -p '>> ' query
	offset=0
	let num_results=$(($(tput lines)/3))
	search
}

function dl_vid(){
	## Get string length of the URL
	size=${#url}
	
	## HTTPS has one more character in the URL to HTTP, so test which one and remove all but the video ID
	id=${url:17:$size}

	## Use the youtube-dl tool to download the file to the temporary directory
	if [ $yt_dl = 'system' ] ; then
		youtube-dl -o /tmp/youtube-ascii/$id $url
	elif [ $yt_dl = 'temp' ] ; then
		/tmp/youtube-ascii/youtube-dl -o /tmp/youtube-ascii/$id $url
	fi
}


function color_pick(){
	## Get preference of color or black and white based on which libraries are installed

	## Check which library they want to use
	echo $'\nWould you like to have black and white [B] ; then or basic color [C] ; then output? (Default: B)' ## $' interprets \n as a new line
	read -p '>> ' color

	## Test first for empty string (default) then for black and white or color
	if [ $color ] ; then
		if [ $color = 'B' ] || [ $color = 'b' ] ; then
			color='black'
		elif [ $color = 'C' ] || [ $color = 'c' ] ; then
			color='color'
		else
			echo "Invalid input"
			color_pick
		fi
	else
		color='black'
	fi
}


function play_vid(){
	## Do they want to be reminded/informed of the mplayer controls?
	echo $'\nMPlayer uses certain keys to play/pause and seek videos in the terminal.\nWould you like to be reminded of what they are? [Y/n] ; then' ## $' interprets \n as a new line
	read -p '>> ' reply
	if [ $reply = 'Y' ] || [ $reply = 'y' ] || [ ! $reply ] ; then
	   echo 'Play/Pause     =>   Space or p'
	   echo 'Seek forward   =>  Right arrow'
	   echo 'Seek backward  =>   Left arrow'
	   echo 'Quit           =>            q'
	   echo $'\nPress enter to continue' ## $' interprets \n as a new line
	   read
	fi
			
	## Actually play the video!
	if [ $color = 'black' ] ; then
		mplayer -vo aa:driver=curses -quiet -monitorpixelaspect 0.5 -x 1366 -y 768 /tmp/youtube-ascii/$id
	elif [ $color = 'color' ] ; then
		CACADRIVER=ncurses
		mplayer -vo caca -quiet -x 1366 -y 768 /tmp/youtube-ascii/$id
	else
		echo "Something went wrong. Exiting."
	fi
	
	asciiTube
}

function asciiTube(){
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
