#!/usr/bin/bash

#query old brigtness
res=$(ddcutil getvcp 10 --bus 10 ; ddcutil setvcp --bus 10 10 ${1} ${2})
#remove spaces
res=${res// /''}
#split by ','
res=(${res//,/' '})
#cut current brightness value
res=$(echo "${res[0]}" | cut -c 38- )
#operate new values from arguments
res=$(bc -l <<< "${res} ${1} ${2}")
#limit up to 100
res=$(( res > 100 ? 100 : res ))
#limit down to 0
res=$(( res < 0 ? 0 : res ))

#Show Gnome OSD
$(dirname "$0")/../osd/osd.sh $res 'display-brightness-symbolic'






