#!/bin/bash

DAEMON_PATH=/Library/LaunchDaemons/
BIN_PATH=/usr/local/bin/
DAEMON_FILE=good.win.ALCPlugFix.plist
VERB_FILE=hda-verb
FIX_FILE=ALCPlugFix

echo "Installing ALCPlugFix v1.6"

# check if the directory "usr/local/bin" exist, if not then create the directory

if [ ! -d "$BIN_PATH" ] ; then 
mkdir "$BIN_PATH" ; 
fi

# stop the daemon if it's already running
if sudo launchctl list | grep --quiet ALCPlugFix; then
    echo "Stopping existing ALCPlugFix daemon."
    sudo launchctl unload $DAEMON_PATH$DAEMON_FILE
fi

# copy over the files to their respective locations (overwrite automatically if files exist)

sudo cp -f ALCPlugFix $BIN_PATH
sudo cp -f hda-verb $BIN_PATH
sudo cp -f good.win.ALCPlugFix.plist $DAEMON_PATH

# set permissions and ownership
sudo chmod 755 $BIN_PATH$FIX_FILE
sudo chown $USER:admin $BIN_PATH$FIX_FILE
sudo chmod 755 $BIN_PATH$VERB_FILE
sudo chown $USER:admin $BIN_PATH$VERB_FILE
sudo chmod 644 $DAEMON_PATH$DAEMON_FILE
sudo chown root:wheel $DAEMON_PATH$DAEMON_FILE

# load and start the daemon
sudo launchctl load -w $DAEMON_PATH$DAEMON_FILE

echo "Done!"
exit 0
