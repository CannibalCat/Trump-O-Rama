#!/bin/bash

# This script will use the .png files inside the 'icon.iconset' folder and recreate the icon.icns file on this folder.

if [ -f icon.icns ]
  then
    rm -f icon.icns
fi

iconutil -c icns icon.iconset