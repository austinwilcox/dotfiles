# Using kmonad with your laptop keyboard
1. You'll want to navigate to /dev/input/by-path/ and find the name of your 
keyboard, for me it was: platform-i8042-serio-0-event-kbd 
2. Next make sure that you have kmonad installed, I installed it via the 
arch user repository, yay kmonad-bin.
3. Then run kmonad colemak-dh-extend-ansi.kbd
4. You will need to leave a terminal open to run the instance,
but now when you type on the keyboard you'll notice the characters map
to Colemak Mod-dh **Alternative to that is to use the below cron script mapped to your user directory and the kmonad executable**

## Cron setup
```
@reboot sudo /home/austin/.dotfiles/kmonad-0.4.1-linux /home/austin/.dotfiles/kmonad-layouts/colemak-dh-extend-ansi.kbd
```

## Windows setup
To set up kmonad to run at startup in windows you will need to create a shortcut at your startup folder.

1. Press `Win + R` and type `shell:startup` to open the startup folder.
2. Create a shortcut to the kmonad executable in this folder.
3. Right-click the shortcut and select `Properties`.
4. In the `Target` field, add the path to your kmonad layout file after the path to the kmonad executable.
5. Click `Apply` to save the changes.
Example:
Target
```shell
"C:\Users\YourUsername\kmonad.exe" "C:\Users\YourUsername\kmonad-layouts\colemak-dh-extend-ansi-win.kbd"
```
