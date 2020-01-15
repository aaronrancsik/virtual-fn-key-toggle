#!/usr/bin/bash
doNotTouchDir=$(dirname "$0")'/doNotTouch'
mkdir -p $doNotTouchDir

LOCKDIR="${doNotTouchDir}/lock"

echo $LOCKDIR

function cleanup {
    if rmdir $LOCKDIR; then
        echo "Finished"
    else
        echo "Failed to remove lock directory '$LOCKDIR'"
        exit 1
    fi
}

custonPath="/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/"

function On(){
    source $(dirname "$0")/config/keyList.conf
    overallbindings=$(gsettings get org.gnome.settings-daemon.plugins.media-keys custom-keybindings)
    overallbindings="${overallbindings::-1}"
    for i in "${!customNameDB[@]}"
    do
        path="$custonPath${customNameDB[i]}"
        
        dconf write "$path/name" "'""${shortcutNameDB[i]}""'"
        dconf write "$path/binding" "'""${shortcutBindingDB[i]}""'"
        dconf write "$path/command" "'""${shortcutCommandDB[i]}""'"

        overallbindings="$overallbindings, '$path/'"
    done
    overallbindings="${overallbindings}]"

    # Update the list of bindings for the shortcuts to work
    dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings "$overallbindings"
}

function Off(){
    overallbindings=$(gsettings get org.gnome.settings-daemon.plugins.media-keys custom-keybindings)
    overallbindings="${overallbindings:1}"
    overallbindings="${overallbindings::-1}"
    IFS_backup=$IFS
    IFS=', ' read -ra bindingsArray <<< "$overallbindings"
    IFS=$IFS_backup

    trunkedBindings=""
    for i in "${bindingsArray[@]}"
    do
        if [[ ! $i == *"custom_virt_fn_"* ]]
        then
            trunkedBindings="$trunkedBindings, $i"
        else       
            ii="${i:1}"
            ii="${ii::-1}"
            dconf reset -f "$ii"
        fi
    done
    trunkedBindings="[${trunkedBindings:2}]"
    dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings "$trunkedBindings"
}

if mkdir $LOCKDIR; then
    #Ensure that if we "grabbed a lock", we release it
    #Works for SIGTERM and SIGINT(Ctrl-C)
    trap "cleanup" EXIT

    echo "Acquired lock, running"
    # Processing starts here
    if test -f $doNotTouchDir/on
    then 
        # It is on, so lets turn off
        
        rm $doNotTouchDir/on
        Off
        $(dirname "$0")/osd/osd.sh "FN KEY RELEASED" "changes-allow-symbolic"
        
    else
        # Its is off, so lets turn on
        touch $doNotTouchDir/on
        On
        $(dirname "$0")/osd/osd.sh "FN KEY LOCKED" "changes-prevent-symbolic"
    fi
else
    echo "Could not create lock directory '$LOCKDIR'"
    exit 1
fi
