#!/bin/bash

echo "Uninstalling ALCPlugFix.  Root user is required."

# check if the root filesystem is writeable (starting with macOS 10.15 Catalina, the root filesystem is read-only by default)
if sudo test ! -w "/"; then
    echo "Root filesystem is not writeable.  Remounting as read-write and restarting Finder."
    sudo mount -uw /
    sudo killall Finder
fi

sudo rm /usr/bin/ALCPlugFix
sudo rm /usr/bin/hda-verb
sudo launchctl unload -w /Library/LaunchDaemons/good.win.ALCPlugFix.plist
sudo launchctl remove good.win.ALCPlugFix
sudo rm /Library/LaunchDaemons/good.win.ALCPlugFix.plist
sudo rm /usr/local/bin/ALCPlugFix
sudo rm /usr/local/bin/hda-verb

echo "Done!"
exit 0
