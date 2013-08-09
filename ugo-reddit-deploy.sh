#!/bin/bash -e
# The contents of this file are subject to the Common Public Attribution
# License Version 1.0. (the "License"); you may not use this file except in
# compliance with the License. You may obtain a copy of the License at
# http://code.reddit.com/LICENSE. The License is based on the Mozilla Public
# License Version 1.1, but Sections 14 and 15 have been added to cover use of
# software over a computer network and provide for limited attribution for the
# Original Developer. In addition, Exhibit A has been modified to be consistent
# with Exhibit B.
#
# Software distributed under the License is distributed on an "AS IS" basis,
# WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for
# the specific language governing rights and limitations under the License.
#
# The Original Code is reddit.
#
# The Original Developer is the Initial Developer.  The Initial Developer of
# the Original Code is reddit Inc.
#
# All portions of the code written by reddit are Copyright (c) 2006-2013 reddit
# Inc. All Rights Reserved.
###############################################################################

###############################################################################
# NOTE(ugo@urbancompass.com, Ugo Di Girolamo):
# I have extracted parts of install-reddit.sh so that I can have a script for
# "fast" deploy of iterative changes to the reddit source.
###############################################################################

set -e
set -u
set -x

# refer to install-reddit.sh for the meaning of these variables.
REDDIT_USER=ugo
REDDIT_HOME=/home/$REDDIT_USER/development
REDDIT_OWNER=ugo

###############################################################################
# Install and configure the reddit code
###############################################################################
cd $REDDIT_HOME/reddit/r2
# TODO(ugo): I don't usually change this, so I'm too lazy to build it.
#sudo -u $REDDIT_OWNER make pyx # generate the .c files from .pyx
sudo -u $REDDIT_OWNER python setup.py build
python setup.py develop

cd $REDDIT_HOME/reddit-i18n/
sudo -u $REDDIT_OWNER python setup.py build
python setup.py develop
sudo -u $REDDIT_OWNER make

# this builds static files and should be run *after* languages are installed
# so that the proper language-specific static files can be generated.
cd $REDDIT_HOME/reddit/r2
sudo -u $REDDIT_OWNER make

cd $REDDIT_HOME/reddit/r2

# NOTE(ugo): in case the .ini or the .update files have been modified.
sudo -u $REDDIT_OWNER make ini

if [ ! -L run.ini ]; then
    sudo -u $REDDIT_OWNER ln -s development.ini run.ini
fi

initctl emit reddit-restart
