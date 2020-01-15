#!/usr/bin/bash

# It`s a proxy layer to make it easy to replace/modify all OSD call in one place.

#replace with your DE`s / WM`s On Screen Displaymanagger call
python3 $(dirname "$0")/gnome-osd.py "$@"