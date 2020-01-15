#!/usr/bin/python3
import dbus
import sys
from subprocess import getoutput, call

label = sys.argv[1]

# Getting the dbus interface to communicate with gnome's OSD
session_bus = dbus.SessionBus()
proxy = session_bus.get_object('org.gnome.Shell', '/org/gnome/Shell')
interface = dbus.Interface(proxy, 'org.gnome.Shell')


logo = sys.argv[2]

# Make dbus method call
interface.ShowOSD({"label":label, "icon":logo})

#"level":size
