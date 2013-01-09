#!/bin/bash

# Copyright (c) 2011  Zotero
#                     Center for History and New Media
#                     George Mason University, Fairfax, Virginia, USA
#                     http://zotero.org
# 
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

CALLDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
. "$CALLDIR/config.sh"
SITE="https://ftp.mozilla.org/pub/mozilla.org/xulrunner/releases/$GECKO_VERSION/runtimes/"

while getopts "p:" opt; do
	case $opt in
		p)
			BUILD_MAC=0
			BUILD_WIN32=0
			BUILD_LINUX=0
			for i in `seq 0 1 $((${#OPTARG}-1))`
			do
				case ${OPTARG:i:1} in
					m) BUILD_MAC=1;;
					w) BUILD_WIN32=1;;
					l) BUILD_LINUX=1;;
					*)
						echo "$0: Invalid platform option ${OPTARG:i:1}"
						usage
						;;
				esac
			done
			;;
	esac
	shift $((OPTIND-1)); OPTIND=1
done

rm -rf xulrunner
mkdir xulrunner
cd xulrunner

if [ $BUILD_MAC == 1 ]; then
	curl -O $SITE/xulrunner-$GECKO_VERSION.en-US.mac.tar.bz2
	tar -xjf xulrunner-$GECKO_VERSION.en-US.mac.tar.bz2
	rm xulrunner-$GECKO_VERSION.en-US.mac.tar.bz2
fi

if [ $BUILD_WIN32 == 1 ]; then
	curl -O $SITE/xulrunner-$GECKO_VERSION.en-US.win32.zip
	
	unzip -q xulrunner-$GECKO_VERSION.en-US.win32.zip
	rm xulrunner-$GECKO_VERSION.en-US.win32.zip
	mv xulrunner xulrunner_win32
fi

if [ $BUILD_LINUX == 1 ]; then
	curl -O $SITE/xulrunner-$GECKO_VERSION.en-US.linux-i686.tar.bz2 \
		-O $SITE/xulrunner-$GECKO_VERSION.en-US.linux-x86_64.tar.bz2 
	
	tar -xjf xulrunner-$GECKO_VERSION.en-US.linux-i686.tar.bz2
	rm xulrunner-$GECKO_VERSION.en-US.linux-i686.tar.bz2
	mv xulrunner xulrunner_linux-i686
	
	tar -xjf xulrunner-$GECKO_VERSION.en-US.linux-x86_64.tar.bz2
	rm xulrunner-$GECKO_VERSION.en-US.linux-x86_64.tar.bz2
	mv xulrunner xulrunner_linux-x86_64
fi