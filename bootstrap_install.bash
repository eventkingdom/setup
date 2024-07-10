#!/bin/bash

#
# Run this script as a first initial script
#	> curl -o bootstrap_install.bash https://raw.githubusercontent.com/eventkingdom/setup/main/bootstrap_install.bash
#	> bash bootstrap_install.bash

if (( $# != 1 ))
then
	printf "\n  Usage: ${0##*/} QS|PRE|PROD (only one parameter acceptable and obligatory)\n\n"
	exit 1
fi
echo $1 | grep -E -q '^(QS|PRE|PROD)$' || die "QS|PRE|PROD argument required, $1 provided"


SVN_BRANCH="branches/PROD_RELEASE"
# shall differ for PRE/PROD (/EventKingdom/branches/PROD_RELEASE => /EventKingdom/trunk)
if [ "QS" == "$1" ]; then
	printf "\n\nDevelopment evironment setup will be used ( $1 )\n\n"
	SVN_BRANCH="trunk"
else
	printf "\n\nPROD/PRE (default) evironment setup will be used: $1\n\n"
fi
echo "SVN repository location: $SVN_BRANCH"
read -p "Confirm it's OK by pressing ENTER to continue.."


# shall differ for PRE/PROD (/EventKingdom/branches/PROD_RELEASE vs QS: /EventKingdom/trunk)
export SVNROOT=https://saas2404h7.saas-secure.com/svn/EventKingdom/$SVN_BRANCH


# shall differ for PRE/PROD (/EventKingdom/branches/PROD_RELEASE => /EventKingdom/trunk)
if grep -q "EventKingdom" $HOME/.profile; then
	echo "Profile file '$HOME/.profile' already configured? Double check manually.."
	exit 1
fi


mkdir -p $HOME/EK/Event.Kingdom
mkdir $HOME/EK/Event.Kingdom.Api
mkdir $HOME/EK/Event.Kingdom.Assets
mkdir $HOME/EK/Event.Kingdom.ImgGeneration
mkdir $HOME/EK/Event.Kingdom.Mail
mkdir $HOME/EK/Event.Kingdom.Translation

cd $HOME/EK

# to enforce 'ekmaster' user (e.g. when system user is not 'ekmaster') use 'svn co --username ekmaster ..' syntax
# or during checkout enter empty password for current user - then you will be asked for user again
svn co $SVNROOT/Event.Kingdom ./Event.Kingdom
svn co $SVNROOT/Event.Kingdom.Api ./Event.Kingdom.Api
svn co $SVNROOT/Event.Kingdom.Assets ./Event.Kingdom.Assets
svn co $SVNROOT/Event.Kingdom.ImgGeneration ./Event.Kingdom.ImgGeneration
svn co $SVNROOT/Event.Kingdom.Mail ./Event.Kingdom.Mail
svn co $SVNROOT/Event.Kingdom.Translation ./Event.Kingdom.Translation


echo -e "\n\n" >> $HOME/.profile
cat $HOME/EK/Event.Kingdom/etc/env/shared$HOME/.profile.addition >> $HOME/.profile

touch $HOME/.eventkingdom
echo -e "\n\nexport SVNROOT=$SVNROOT\n\n" >> $HOME/.eventkingdom
if [ "PROD" != "$1" ]; then
	# change SVN location to development/head/trunk
	echo -e "export EK_DEV_ENV=\"$1\"\n" >> $HOME/.eventkingdom
	if [ "QS" == "$1" ]; then
		echo -e "export EK_DEPLOYMENT_TYPE=\"TEST\"\n" >> $HOME/.eventkingdom
	fi
fi

# prepare mp3 upload directory
sudo mkdir /var/www/mp3
sudo chown ekmaster:ekmaster /var/www/mp3

chmod a+x ~/EK/Event.Kingdom/etc/env/shared/bootstrap_*
chmod a+x ~/EK/Event.Kingdom/etc/env/shared/setup_*
chmod a+x ~/EK/Event.Kingdom/etc/env/transfer/pull_*


printf "\n\nRestart SSH session/relogin now.\nThen run '~/EK/Event.Kingdom/etc/env/shared/bootstrap_setup'\n\n"
