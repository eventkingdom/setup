#!/bin/bash

###
# > curl -o swap_svn.bash https://raw.githubusercontent.com/eventkingdom/setup/main/swap_svn.bash
# > bash swap_svn.bash
###

SVNROOT="https://ekmaster@saas2404h7.saas-secure.com/svn/EventKingdom/branches/PROD_RELEASE"


# Event.Kingdom project - just remove we don't need it at all here
if [ -d "Event.Kingdom" ]; then
	mv -v Event.Kingdom _xpdev_Event.Kingdom
fi

# Event.Kingdom.Assets project
mv -v Event.Kingdom.Assets _xpdev_Event.Kingdom.Assets
mkdir Event.Kingdom.Assets
svn co --username ekmaster ${SVNROOT}/Event.Kingdom.Assets ./Event.Kingdom.Assets

# Event.Kingdom.ImgGeneration project
mv -v Event.Kingdom.ImgGeneration _xpdev_Event.Kingdom.ImgGeneration
mkdir Event.Kingdom.ImgGeneration
svn co --username ekmaster ${SVNROOT}/Event.Kingdom.ImgGeneration ./Event.Kingdom.ImgGeneration

# copy local config files
cp -v _xpdev_Event.Kingdom.ImgGeneration/www/config.php Event.Kingdom.ImgGeneration/www/
cp -v _xpdev_Event.Kingdom.ImgGeneration/www/constants.php Event.Kingdom.ImgGeneration/www/

# File /www/generation/mudraw.exe
# Go to "Properties/Security" leave only "Everyone/Administrator/None" entries.
# Set "Full control" for "Everyone" entry.
echo ""
echo "Now FIX /www/generation/mudraw.exe permissions"
