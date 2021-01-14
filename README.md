# wallblur

wallblur is a simple shell script that creates a faux blurred background effect for your linux desktop without needing a compositor.

<p align="center">
If you would like to show your appreciation for this project,<br>please consider a donation :)<br><br>
<a href="https://www.paypal.com/donate/?business=Y4Y75KP2JBNJW&currency_code=USD">
<img src="https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif" alt="PayPal donation link"/></a>
<p>

![demo](https://github.com/turing753/wallblur/blob/master/demo.gif)

## Getting Started

### Dependencies

In order to use the script, you will need to make sure you have imagemagick, feh and wmctrl installed.

If not, you can do so by executing:

```
sudo apt install imagemagick wmctrl feh
```

### pywal users

If you are a pywal user, you would probably want to use the "wallblur.sh" script. It will automatically read your current wallpaper from the pywal cache.

It will also detect when you change your wallpaper, and update its cache accordingly.

Moreover, it will also resize your wallpaper while mantaining aspect ratio so that it fits your display's resolution. Don't worry, it will not modify the original file.

### non-pywal users

If you do not use pywal, you will need to use the "wallblur_nopywal.sh" script.

Specify your current wallpaper as an input argument like so:  

```
path/to/wallblur_nopywal.sh -i ~/wallpapers/mywallpaper.jpg &
```

Similar to the pywal version, the script will automatically resize your wallpaper while mantaining aspect ratio so that it fits your display's resolution. Don't worry, it will not modify the original file.

### users on gnome or cinnamon desktop environments

If you fit under this category, you will need to use the "wallblur_gnome_cinnamon.sh" script.

### Note

Make sure that you stop any existing application that is responsible for setting your wallpaper.


## Running wallblur

### the manual way

You can run wallblur by running the following command:

```
path/to/wallblur.sh &
```

If you are copying and pasting the script instead of downloading the script. Make sure you make it executable by using the following command:

```
chmod +x path/to/wallblur.sh
```

Of course, replacing **wallblur.sh** with the name of the script. 

### automatically start wallblur on startup

If you are using **cinnamon or gnome**, add ```path/to/_gnome_cinnamon.sh &``` as a custom command in your "Startup Applications" instead of ```.xprofile```. Make sure to provide the actual full path, without $HOME or ~.


Otherwise, if you would like to start wallblur on startup automatically, assuming you are on an X11 windowing system, add the following line to your **.xprofile** file:

```
path/to/wallblur.sh &
```

Replacing ***path/to/*** with the actual path where the script is residing.

And if you are using **i3wm**, you can add this line to your config:

```
exec --no-startup-id sh -c "path/to/wallblur.sh &"
```
