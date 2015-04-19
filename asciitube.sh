#!/bin/bash

function at_help(){
cat << "EOF"
    Usage:  asciitube.sh [options]
    
    Options:
    -c              Use libcaca for colorized ASCII output
    -b              Use aalib for black and white ASCII output
    -s <query>      Search query (surround in quotes if there is a space)
    
EOF
}

function at_install(){
    mkdir -p "/opt/asciitube/scripts"
    install -m775 $(pwd)/asciitube.sh "/opt/asciitube/"
    install -m775 $(pwd)/scripts/* "/opt/asciitube/scripts/"
    ln -s /opt/asciitube/asciitube.sh /usr/bin/asciitube
}

lowercase(){
    echo $1 | tr '[:upper:]' '[:lower:]'
}

function prepare(){
	old_dir=$(pwd)
	shell_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
	cd $shell_dir
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
	#if [ ! query ]; then
            echo -e "\nWhat would you like to watch?"
            read -p '>> ' query
        #fi
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
		youtube-dl -o /tmp/asciitube/$id $url
	elif [ $yt_dl = 'temp' ] ; then
		/tmp/asciitube/youtube-dl -o /tmp/asciitube/$id $url
	fi
}


function color_pick(){
	## Get preference of color or black and white based on which libraries are installed

	## Check which library they want to use
	echo $'\nWould you like to have black and white [B] ; then or basic color [C] ; then output? (Default: B)' ## $' interprets \n as a new line
	read -p '>> ' color
        color=$(lowercase $color)
	## Test first for empty string (default) then for black and white or color
	if [ $color ] ; then
		if [ $color = 'b' ] ; then
			color='black'
		elif [ $color = 'c' ] ; then
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
	echo $'\nMPlayer uses certain keys to play/pause and seek videos in the terminal.\nWould you like to be reminded of what they are? [Y/n]' ## $' interprets \n as a new line
	read -p '>> ' reply
	if [ $reply = 'y' ] || [ ! $reply ] ; then
	   echo 'Play/Pause     =>   Space or p'
	   echo 'Seek forward   =>  Right arrow'
	   echo 'Seek backward  =>   Left arrow'
	   echo 'Quit           =>            q'
	   echo $'\nPress enter to continue' ## $' interprets \n as a new line
	   read
	fi
			
	## Actually play the video!
	if [ $color = 'black' ] ; then
		mplayer -vo aa:driver=curses -quiet -monitorpixelaspect 0.5 /tmp/asciitube/$id
	elif [ $color = 'color' ] ; then
		CACADRIVER=ncurses
		mplayer -vo caca -fs -quiet /tmp/asciitube/$id
	else
		echo "Something went wrong. Exiting."
		exit
	fi
	
	cd $old_dir
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

	if [ ! $url ]; then
            first_search
        fi
	dl_vid
	if [ ! $color ]; then
            color_pick
        fi
	play_vid
	clear
}

######################################################################
##                                                                  ##
##                    RUN THE ACTUAL PROGRAM HERE                   ##
##                                                                  ##
######################################################################
while getopts cbs:ih flag; do
    case $flag in
        c)
            color="color"
            ;;
        b)
            color="black"
            ;;
        s)
            query="$OPTARG"
            ;;
        i) 
            if [ $EUID != 0 ] ; then
                at_install
            else
                echo "Installing requires running as root. Exiting."
            fi
            ;;
        h)
            at_help
            exit
            ;;
        ?/)
            at_help
            exit
            ;;
    esac
done
shift $((OPTIND-1)) # Honestly I'm not sure what this is for, but a tutorial I read had it so I included it

prepare
asciiTube
