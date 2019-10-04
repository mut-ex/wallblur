#!/bin/bash

# To get the current wallpaper
source ~/.cache/wal/colors.sh
curr_wallpaper="$wallpaper"
cache_dir="$HOME/.cache/wallblur"

basefilename=$(basename -- "$curr_wallpaper")
extension="${basefilename##*.}"
filename="${basefilename%.*}"

echo $cache_dir

if [ ! -d "$cache_dir" ]; then
	echo "* Creating cache directory..."
    mkdir -p "$cache_dir"
fi

gen_blurred_seq () {
	for i in $(seq 0 1 5)
	do
		blurred_wallaper=""$cache_dir"/"$filename""$i"."$extension""
  		convert -blur 0x$i $curr_wallpaper $blurred_wallaper
        echo " > Generating... $(basename $blurred_wallaper)"
    done
}


do_blur () {
	for i in $(seq 5)
	do
		blurred_wallaper=""$cache_dir"/"$filename""$i"."$extension""
		feh --bg-fill "$blurred_wallaper" 
    done
}

do_unblur () {
	for i in $(seq 5 -1 0)
	do
		blurred_wallaper=""$cache_dir"/"$filename""$i"."$extension""
		feh --bg-fill "$blurred_wallaper" 
    done
}

blur_cache=""$cache_dir"/"$filename"0."$extension""

if [ ! -f "$blur_cache" ]
    then
        notify-send "Generating blured wallpaper: "$basefilename"..."

        if [  "$(ls -A "$cache_dir")" ]; then
			echo " * Cleaning existing cache..."
			rm -r "$cache_dir"/*
		fi

        gen_blurred_seq
fi

while :; do
	current_workspace="$(xprop -root _NET_CURRENT_DESKTOP | awk '{print $3}')"
	num_windows="$(echo "$(wmctrl -l)" | awk -F" " '{print $2}' | grep ^$current_workspace)"

	if [ -n "$num_windows" ]
	    then
	        if [ "$prev_state" != "blurred" ]
	            then
	            	echo " ! Blurring"
	                do_blur
	        fi
	        prev_state="blurred"
	    else
	        if [ "$prev_state" != "unblurred" ]
	            then
	            	echo " ! Un-blurring"
	                do_unblur
	        fi
	        prev_state="unblurred"
	fi
	sleep 0.3
done
