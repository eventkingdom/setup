#!/bin/bash

####
# bootstrap BA mail server environment
# subversion needs to be installed already
####

mkdir -p ~/EK/Event.Kingdom.Mail
mkdir -p ~/EK/Event.Kingdom.Translation

cd ~/EK
svn co --username ekbaupdater ${SVNROOT}/Event.Kingdom.Mail ./Event.Kingdom.Mail
svn co --username ekbaupdater ${SVNROOT}/Event.Kingdom.Translation ./Event.Kingdom.Translation
