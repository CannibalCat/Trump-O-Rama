#!/bin/bash

# This script will build the Mac export and make sure the TrumpORama.app has a proper Mac icon.

pushd ..
openfl build mac
popd
./update_icon.sh
cp icon.icns ../export/mac64/cpp/bin/TrumpORama.app/Contents/Resources/