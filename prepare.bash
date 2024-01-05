#!/bin/bash

mkdir -p ~/EK/Event.Kingdom.Mail
cd ~/EK

# to enforce 'ekmaster' user (e.g. when system user is not 'ekmaster') use 'svn co --username ekmaster ..' syntax
# or during checkout enter empty password for current user - then you will be asked for user again
svn co --username ekmaster ${SVNROOT}/Event.Kingdom.Mail ./Event.Kingdom.Mail

mkdir -p ~/collected-mails
mkdir -p ~/processed

cp -f ~/EK/Event.Kingdom.Mail/etc/env/common/home/_common/bin/update.bash ~/bin/
bash ~/bin/update.bash
