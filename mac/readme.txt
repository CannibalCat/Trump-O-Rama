May 7th 2016.

./build.sh
Creates a 'TrumpORama.app' inside the ../export/mac64/cpp/bin folder.

This script uses the ./update_icon.sh script of this same folder which creates a Mac icon file
which is used by the build script to update the TrumpORama.app file. For some reason Haxe/OpenFL does
not include an icon when it does the export, so we take care of it.

The current icon.icns file only contains a 256x256 png image.
If you want to re-create a bettr icon.icns file, add more .png files into the "icon.iconset" folder.
Important: the new png files you add must be named "icon_<size>x<size>.png" otherwise the icon creating script will fail.
