# Using kmonad with your laptop keyboard
1. You'll want to navigate to /dev/input/by-path/ and find the name of your 
keyboard, for me it was: platform-i8042-serio-0-event-kbd 
2. Next make sure that you have kmonad installed, I installed it via the 
arch user repository, yay kmonad-bin.
3. Then run kmonad colemak-dh-extend-ansi.kbd
4. You will need to leave a terminal open to run the instance,
but now when you type on the keyboard you'll notice the characters map
to Colemak Mod-dh. **To have it start automatically, use the systemd service
below instead of leaving a terminal open.**

## Linux autostart (systemd)
`kmonad.service` in this directory is a system unit that runs the homerow
layout as root. Install it once:

```shell
sudo /home/austin/.dotfiles/kmonad/install-systemd.sh
```

That symlinks the unit into `/etc/systemd/system/`, deletes the old
`@reboot ... kmonad` line from `/etc/crontab` (keeping a backup), kills the
cron-started instance, and enables + starts the service.

Day-to-day:

```shell
systemctl status kmonad         # is it running
sudo systemctl restart kmonad   # pick up .kbd edits
sudo systemctl stop kmonad      # back to the raw QWERTY keyboard
journalctl -u kmonad -f         # logs, e.g. wrong input device
```

The unit is a symlink to the repo copy, so editing `kmonad.service` only needs
`sudo systemctl daemon-reload && sudo systemctl restart kmonad`. To use a
different layout, change `ExecStart` in `kmonad.service`.

`Restart=always` is deliberate: the keyboard may not be enumerated yet at boot,
and unplugging an external board makes kmonad exit.

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
