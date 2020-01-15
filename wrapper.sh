#!/usr/bin/env bash

IFS_backup=$IFS
IFS_line="
"

IFS=$IFS_line
connectedDisplays=($(xrandr | awk '/connected/ {print $0}'))
IFS=$IFS_backup

displays=()
for i in "${connectedDisplays[@]}"
do
    #get screen settings ex. 1920x1200+1920+0
    settings=$(echo $i | grep -Eoh "([0-9]+[x][0-9]+[+][0-9]+[+][0-9]+)")
    
    if [ ! -z $settings ]
    then
    
        #separate parts by ' ' spaces
        settings=($(echo $settings | tr "+" "x" | tr "x" " "))

        #calc coordinates: 0. start x, 1. end x, 2. start y, 3. end y
        coordinates=(${settings[2]})
        coordinates+=($((${settings[2]}+${settings[0]})))
        coordinates+=(${settings[3]})
        coordinates+=($((${settings[3]}+${settings[1]})))
 
        IFS=$IFS_line
	    displays+=($(printf "%s " "${coordinates[@]}" &&  echo $i | awk '{print " "$1}'))
        IFS=$IFS_backup
    fi
done

## Get mouse position
mouseQuery=($(xdotool getmouselocation --shell))

# 0. x, 1. y
mouseCoordinates=($(echo ${mouseQuery[0]} | grep "X=" | cut -c 3-))
mouseCoordinates+=($(echo ${mouseQuery[1]} | grep "Y=" | cut -c 3-))

for i in "${displays[@]}"
do
    
    xStart=$(echo ${i[0]} | awk '{print $1}')
    xEnd=$(echo ${i[0]} | awk '{print $2}')
    yStart=$(echo ${i[0]} | awk '{print $3}')
    yEnd=$(echo ${i[0]} | awk '{print $4}')
    screenName=$(echo ${i[0]} | awk '{print $5}')
    
    if (( mouseCoordinates[0] > xStart )) &&  (( mouseCoordinates[0] < xEnd )) && (( mouseCoordinates[1] > yStart )) && (( mouseCoordinates[1] < yEnd )) 
    then
        currentDisplay=$screenName
        break
    fi
done


source $(dirname "$0")/config/displayList.conf
for d in "${displayDB[@]}"
do
    if [[ $currentDisplay = $(echo $d | awk '{print $1}') ]]
    then
        $(dirname "$0")/commands/$(echo $d | awk '{print $2}') $@
    fi
done

