#!/bin/bash

####
# call this script to update environment (scripts/config files) from svn
####

HOSTNAME=$(hostname)

DOMAIN=${HOSTNAME#*\.}
SUBDOMAIN=${HOSTNAME%%\.*}

# "server class" is "mail" or "nail"
SERVER_CLASS=$SUBDOMAIN


if [[ ${#SUBDOMAIN} -ge 5 ]]; then
	echo "Alternative \"${SUBDOMAIN:0:1}\" server setup"
	SERVER_CLASS=${SUBDOMAIN:1}
fi

echo "Server class: ${SERVER_CLASS}"
echo " == "


cd ~/EK
svn up *

# (1) get the most basic "common" scripts always
echo "- Copy common scripts."
echo "  <<  ~/EK/Event.Kingdom.Mail/etc/env/common/home/_common/bin/"
rsync -av ~/EK/Event.Kingdom.Mail/etc/env/common/home/_common/bin/ ~/bin/
cp -vf ~/EK/Event.Kingdom.Mail/etc/env/common/home/_common/.my.cnf ~/

# (2) get "common" version of this user scripts (if any)
if [[ -d ~/EK/Event.Kingdom.Mail/etc/env/common/home/$LOGNAME/bin ]]; then
	echo "- Copy common $LOGNAME user scripts."
	echo "  <<  ~/EK/Event.Kingdom.Mail/etc/env/common/home/$LOGNAME/bin"
	rsync -av ~/EK/Event.Kingdom.Mail/etc/env/common/home/$LOGNAME/bin/ ~/bin/
fi

# (3) now get the "server class" version of this user scripts (if any)
if [[ -d ~/EK/Event.Kingdom.Mail/etc/env/${SERVER_CLASS}/home/$LOGNAME/bin ]]; then
	echo "- Copy ${SERVER_CLASS} more general $LOGNAME user scripts."
	echo "  <<  ~/EK/Event.Kingdom.Mail/etc/env/${SERVER_CLASS}/home/$LOGNAME/bin"
	rsync -av ~/EK/Event.Kingdom.Mail/etc/env/${SERVER_CLASS}/home/$LOGNAME/bin/ ~/bin/
fi

# (4) even more specific files (host/server dedicated)
if [[ ${#SUBDOMAIN} -ge 5 ]]; then
	# (4.1) if "alternative" server (files for anail.eventkingdom.com shall overwrite more general nail.eventkingdom.com files)
	if [ -d ~/EK/Event.Kingdom.Mail/etc/env/${HOSTNAME:1}/$HOSTNAME/home/$LOGNAME/bin ]; then
		echo "- Copy ${HOSTNAME:1} alternative host $LOGNAME user scripts."
		echo "  <<  ~/EK/Event.Kingdom.Mail/etc/env/${HOSTNAME:1}/$HOSTNAME/home/$LOGNAME/bin"
		rsync -av ~/EK/Event.Kingdom.Mail/etc/env/${HOSTNAME:1}/$HOSTNAME/home/$LOGNAME/bin/ ~/bin/
	fi
else
	# (4.2) if NOT "alternative" server - check if there are "host" dedicated files
	if [ -d ~/EK/Event.Kingdom.Mail/etc/env/$HOSTNAME/home/$LOGNAME/bin ]; then
		echo "- Copy host ${HOSTNAME} dedicated $LOGNAME user scripts."
		echo "  <<  ~/EK/Event.Kingdom.Mail/etc/env/$HOSTNAME/home/$LOGNAME/bin"
		rsync -av ~/EK/Event.Kingdom.Mail/etc/env/$HOSTNAME/home/$LOGNAME/bin/ ~/bin/
	fi
fi


# call any "local" updates extensions
# this scripts will inherit all variables created in current script
for filename in $HOME/bin/__update_*.bash; do
	if [[ ! -e "$filename" ]]; then continue; fi
	echo " > running $filename"
	. $filename
done


# FIXME TODO we shall make only *.bash executable
chmod a+x ~/bin/*
