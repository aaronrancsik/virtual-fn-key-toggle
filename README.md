## EARLY ACCESS, BETA STAGE

# Virtual fn-key toggle
A better, software driven, hackable fn / function key manager for linux.

Mostly written in  Bash shell script and a lil-bit Python.

(I hope) Its modular and portable to any desktop enviroment or window manager, but my main developement under Gnome at this time :)
## For:
* Replace / bypass hardware solutions.
* If hardware`s ACPI call based solution not work.
* Create fully custom keyboard shortcut behaviors.

## State toggle
State can be toggle with arbitary shortcut combination.

## Locked state
In this state all F keys can act as hotkey, or function key.
All F key can use for Brighness and Volume controll and so on.
Arbitary command bindable for keyboard keys via shortcuts _*and/or keyboard layout remap with xmodmap <- under developement_

## Released state
In this state all F key work as normal F1..F12 function keys.
All the shortcuts which was created by toggle is removed now.

## Mouse location based custom brightness controll for all displays or monitors 
Based-on wich display under the mouse, the brightness up/down key can execute different command.
This make possible to controll even external monitors hardware settings via DDC/CI protocol, 
and the same time, you can  controll laptop screen backlight with dbus.
If your monitor hardware dose not support any of this option above, you can still use the `xrandr --gamma <xx> --brightness <xx>` option which is software based but better than nothing especially with OLED displays.

## Gnome on screen dispay 
Show Gnomes`s on screen display which indicate the brightness state in a OSD pop-up.

## Cotrib
Feel free to send (open issue) any suggestion, or create PR.
