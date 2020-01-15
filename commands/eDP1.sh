#!/usr/bin/bash

#Increase or Decrease?
if [ "${1}" = "+" ]
    then 
        step="StepUp"
    else 
        step="StepDown"   
fi

#call gnome dbus
res=$(gdbus call --session --dest org.gnome.SettingsDaemon.Power --object-path /org/gnome/SettingsDaemon/Power --method org.gnome.SettingsDaemon.Power.Screen."${step}")
#remove spaces
res=(${res//,/ })
#cut current brightness value
res=$(echo "${res[0]}" | cut -c 2- )

echo $res


#Show Gnome OSD
$(dirname "$0")/../osd/osd.sh $res 'display-brightness-symbolic'