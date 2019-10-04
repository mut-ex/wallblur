#!/bin/bash


### ---- Global variables ----

### Never changing
curr_user=$(whoami)
cache_dir="/home/"$curr_user"/.cache/wallblur"
last_wallpaper_cache="$cache_dir/wallpaper.jpeg"
gnome_wallpaper_cache="/home/${curr_user}/.cache/wallpaper"
basefilename=$(basename -- "$last_wallpaper_cache")
extension="${basefilename##*.}"
filename="${basefilename%.*}"

# Will be populated/changed after the first loop iteration
last_wallpaper=""
prev_state=""
wallpaper_set_by_this=false


### ---- Helper functions ----

### Called when a new wallpaper is detected
settle_new_wallpaper() {
	### Remove old cache dir and recreate it
	if [  "$(ls -A "$cache_dir")" ]; then
			echo " * Cleaning existing cache..."
			rm -r "$cache_dir"/*
	fi
	mkdir -p $cache_dir

	### Copy the new wallpaper in cache as a jpeg
	### (the original is a jpeg, but doesn't have the extension)
	cp "$gnome_wallpaper_cache/$last_wallpaper" $last_wallpaper_cache
}

gen_blurred_seq () {
	### Send a notification
	#notify-send "Generating blured wallpaper: "$basefilename"..."

	### Generate incrementally blurred images
	for i in $(seq 0 1 5)
	do
		blurred_wallpaper=""$cache_dir"/"$filename""$i"."$extension""
  		convert -blur 0x$i $last_wallpaper_cache $blurred_wallpaper
        echo " > Generating... $(basename $blurred_wallpaper)"
    done
}


do_blur () {
	for i in $(seq 5)
	do
		blurred_wallpaper=""$cache_dir"/"$filename""$i"."$extension""
		gsettings set org.gnome.desktop.background picture-uri file:///"$blurred_wallpaper"

    done
}

do_unblur () {
	for i in $(seq 5 -1 0)
	do
		blurred_wallpaper=""$cache_dir"/"$filename""$i"."$extension""
		gsettings set org.gnome.desktop.background picture-uri file:///"$blurred_wallpaper"

    done
}


### ---- Main execution ----

echo "Cache dir: $cache_dir"

### If there is a wallpaper in cache, assume it was the last used
### That's so that it doesn't consider the blurred as the normal
### upon restart
if [ -f "$last_wallpaper_cache" ]; then
	wallpaper_set_by_this=true
fi

### Main loop
while :; do
	curr_wallpaper="$(ls -A $gnome_wallpaper_cache)"
	
	### Check if the wallpaper changed by this script
	if [ "$wallpaper_set_by_this" = true ]; then
		last_wallpaper=$curr_wallpaper
		wallpaper_set_by_this=false
	fi

	### Check if the wallpaper has changed
	if [ ! "$curr_wallpaper" = "$last_wallpaper" ]; then
		echo "* The wallpaper changed"
		last_wallpaper=$curr_wallpaper
		settle_new_wallpaper
		gen_blurred_seq
		prev_state="" # Reset
	fi

	### Find current workspace
	current_workspace="$(xprop -root _NET_CURRENT_DESKTOP | awk '{print $3}')"
	
	### Find number of windows in said workspace
	### TODO: See if there is a way to get only un-minimized windows
	num_windows="$(echo "$(wmctrl -l)" | awk -F" " '{print $2}' | grep ^$current_workspace)"

	### Blur/Unblur
	if [ -n "$num_windows" ]
	    then
	        if [ "$prev_state" != "blurred" ]; then
            	echo " ! Blurring"
                do_blur
                wallpaper_set_by_this=true
        		prev_state="blurred"
	        fi
	    else
	        if [ "$prev_state" != "unblurred" ]; then
            	echo " ! Un-blurring"
                do_unblur
                wallpaper_set_by_this=true
        		prev_state="unblurred"
	        fi
	fi

	sleep 0.3
done
