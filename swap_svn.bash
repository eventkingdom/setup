#!/bin/bash

###
# > curl https://raw.githubusercontent.com/eventkingdom/setup/main/swap_svn.bash
# > bash swap_svn.bash
###

if [ -d "${HOME}/EK" ]; then

	if [ -d "${HOME}/_xpdev_EK" ]; then
		echo "Folder ${HOME}/_xpdev_EK already exists - remove and try again"
		exit 1
	fi

	echo "Backing up ${HOME}/EK as ${HOME}/_xpdev_EK"
	mv ${HOME}/EK ${HOME}/_xpdev_EK

	mkdir ${HOME}/EK
	cd ${HOME}/EK

	for f in ${HOME}/_xpdev_EK/Event.King* ; do
		if [ -d "$f" ]; then
			# $f is full path like /home/ekmaster/EK/Event.Kingdom.Api
			# we extract token after last slash(/)
			EK_PROJ="${f##*/}"

			echo "Recreating $EK_PROJ"
			mkdir -p ${HOME}/EK/${EK_PROJ}
			echo "Downloading sources of $EK_PROJ"
			svn co --username ${USER} ${SVNROOT}/${EK_PROJ} ./${EK_PROJ}
		fi
	done

	# copy local files
	echo "Reusing local config files.."
	if [ -f "${HOME}/_xpdev_EK/Event.Kingdom.Api/etc/local.properties" ]; then
		cp -v ${HOME}/_xpdev_EK/Event.Kingdom.Api/etc/local.properties ${HOME}/EK/Event.Kingdom.Api/etc/local.properties
		cp -v ${HOME}/_xpdev_EK/Event.Kingdom.Api/etc/release.properties ${HOME}/EK/Event.Kingdom.Api/etc/release.properties
	fi
	if [ -f "${HOME}/_xpdev_EK/Event.Kingdom.Assets/www/.htpasswd" ]; then
		mv -v ${HOME}/_xpdev_EK/Event.Kingdom.Assets/www/.htpasswd ${HOME}/EK/Event.Kingdom.Assets/www/.htpasswd
	fi

	echo "Remounting users mp3 storage.."
	mv -v ${HOME}/_xpdev_EK/Event.Kingdom.Assets/www/mp3/users ${HOME}/EK/Event.Kingdom.Assets/www/mp3/users

fi


if [ -d "${HOME}/BA" ]; then

	if [ -d "${HOME}/_xpdev_BA" ]; then
		echo "Folder ${HOME}/_xpdev_BA already exists - remove and try again"
		exit 2
	fi

	echo "Backing up ${HOME}/BA as ${HOME}/_xpdev_BA"
	mv ${HOME}/BA ${HOME}/_xpdev_BA

	mkdir ${HOME}/BA
	cd ${HOME}/BA

	for f in ${HOME}/_xpdev_BA/Event.King* ; do
		if [ -d "$f" ]; then
			# $f is full path like /home/ekmaster/EK/Event.Kingdom.Api
			# we extract token after last slash(/)
			EK_PROJ="${f##*/}"

			echo "Recreating $EK_PROJ"
			mkdir -p ${HOME}/BA/${EK_PROJ}
			echo "Downloading sources of $EK_PROJ"
			svn co --username ${USER} ${SVNROOT}/${EK_PROJ} ./${EK_PROJ}
		fi
	done

	echo "Remounting scripts.."
	mv ${HOME}/_xpdev_BA/bin ${HOME}/BA/bin

fi
