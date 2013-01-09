#!/bin/bash

# Copyright (c) 2012  XULApp StarterKit racklin@gmail.com
#
#
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

[ "`uname`" != "Darwin" ]
MAC_NATIVE=$?
[ "`uname -o 2> /dev/null`" != "Cygwin" ]
WIN_NATIVE=$?

function usage {
	cat >&2 <<DONE
Usage: $0 [-p PLATFORMS] [-s DIR] [-v VERSION] [-c CHANNEL] [-d]
Options
 -p PLATFORMS        build for platforms PLATFORMS (m=Mac, w=Windows, l=Linux)
 -v VERSION          use version VERSION
 -c CHANNEL          use update channel CHANNEL
 -d                  don't package; only build binaries in staging/ directory
DONE
	exit 1
}

PACKAGE=1
while getopts "p:s:v:c:d" opt; do
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
		s)
			SYMLINK_DIR="$OPTARG"
			PACKAGE=0
			;;
		v)
			VERSION="$OPTARG"
			;;
		c)
			UPDATE_CHANNEL="$OPTARG"
			;;
		d)
			PACKAGE=0
			;;
		*)
			usage
			;;
	esac
	shift $((OPTIND-1)); OPTIND=1
done

if [ ! -z $1 ]; then
	usage
fi

BUILDID=`date +%Y%m%d`

shopt -s extglob
mkdir "$BUILDDIR"

if [ -z "$UPDATE_CHANNEL" ]; then
    UPDATE_CHANNEL="default"
fi

echo "Building XULApp StarterKit"

# Copy app directory
cp -RH "$CALLDIR/app/"* "$BUILDDIR/"
REV=`git log -n 1 --pretty='format:%h'`

if [ -z "$VERSION" ]; then
    VERSION="$DEFAULT_VERSION_PREFIX$REV"
fi

# Append version directory to DISTDIR
DISTDIR="$DISTDIR/$VERSION"

# Make sure DISTDIR exists
if [ ! -d "$DISTDIR" ]; then mkdir -p "$DISTDIR"; fi

# Delete files that shouldn't be distributed
find "$BUILDDIR/chrome/" -depth -type d -name .git -exec rm -rf {} \;
find "$BUILDDIR/chrome/" -name .DS_Store -exec rm -f {} \;

# Zip chrome into JAR
cd "$BUILDDIR/chrome"
# Checkout failed -- bail
if [ $? -eq 1 ]; then
    exit;
fi
zip -0 -r -q ../$MODULE.jar branding content locale skin
rm -rf "$BUILDDIR/chrome/"branding
rm -rf "$BUILDDIR/chrome/"content
rm -rf "$BUILDDIR/chrome/"locale
rm -rf "$BUILDDIR/chrome/"skin
mv ../$MODULE.jar .
cd ..

# modify chrome.manifest
perl -pi -e 's/chrome\//jar:chrome\/'$MODULE'.jar\!\//g' "$BUILDDIR/chrome.manifest"

# modify application.ini
perl -pi -e "s/^Version=.*/Version=$VERSION/" "$BUILDDIR/application.ini"
perl -pi -e "s/^BuildID=.*/BuildID=$BUILDID/" "$BUILDDIR/application.ini"
perl -pi -e "s/^Profile=.*/Profile=$PROFILE/" "$BUILDDIR/application.ini"

#  modify update.js
perl -pi -e 's/pref\("app\.update\.channel", "[^"]*"\);/pref\("app\.update\.channel", "'"$UPDATE_CHANNEL"'");/' "$BUILDDIR/defaults/preferences/update.js"
#  modify prefs.js
perl -pi -e 's/%GECKO_VERSION%/'"$GECKO_VERSION"'/g' "$BUILDDIR/defaults/preferences/prefs.js"

# Delete .DS_Store and .git
find "$BUILDDIR" -depth -type d -name .git -exec rm -rf {} \;
find "$BUILDDIR" -name .DS_Store -exec rm -f {} \;

cd "$CALLDIR"

# Make sure STAGEDIR exists
if [ ! -d "$STAGEDIR" ]; then mkdir -p "$STAGEDIR"; fi

# Mac
if [ $BUILD_MAC == 1 ]; then
	echo "Building $APPNAME.app"

	# Set up directory structure
	APPDIR="$STAGEDIR/$APPNAME.app"
	rm -rf "$APPDIR"
	mkdir "$APPDIR"
	chmod 755 "$APPDIR"
	cp -r "$CALLDIR/mac/Contents" "$APPDIR"
	CONTENTSDIR="$APPDIR/Contents"

	# Merge xulrunner and relevant assets
	mkdir "$CONTENTSDIR/MacOS"
	mkdir "$CONTENTSDIR/Resources"
	cp -a "$MAC_RUNTIME_PATH/Versions/Current"/* "$CONTENTSDIR/MacOS"

	# Mozilla no longer builds xulrunner-stub on OS X
	mv "$CONTENTSDIR/MacOS/xulrunner" "$CONTENTSDIR/MacOS/$MODULE-bin"
	cp "$CALLDIR/mac/$MODULE" "$CONTENTSDIR/MacOS/$MODULE"
	# Hack to get the updater to work
	mv "$CONTENTSDIR/MacOS/updater.app/Contents/MacOS/updater" "$CONTENTSDIR/MacOS/updater.app/Contents/MacOS/updater-bin"
	cp "$CALLDIR/mac/updater" "$CONTENTSDIR/MacOS/updater.app/Contents/MacOS/updater"
	cp "$CALLDIR/mac/Contents/Info.plist" "$CONTENTSDIR"
	cp "$CALLDIR/app/chrome/icons/default/default.icns" "$CONTENTSDIR/Resources/$MODULE.icns"

	# Copy plugins
	if [ $BUNDLE_PLUGINS == 1 ]; then
		mkdir -p "$CONTENTSDIR/Resources/plugins/"
		cp -r "$CALLDIR/plugins/mac/"* "$CONTENTSDIR/Resources/plugins/"
	fi

	# Modify Info.plist
	cp "$CALLDIR/mac/Contents/Info.plist" "$CONTENTSDIR/Info.plist"
	perl -pi -e "s/{{VERSION}}/$VERSION/" "$CONTENTSDIR/Info.plist"
	perl -pi -e "s/{{VERSION_NUMERIC}}/$VERSION_NUMERIC/" "$CONTENTSDIR/Info.plist"
	# Needed for "monkeypatch" Windows builds:
	# http://www.nntp.perl.org/group/perl.perl5.porters/2010/08/msg162834.html
	rm -f "$CONTENTSDIR/Info.plist.bak"

	# Add components
	cp -R "$BUILDDIR/"* "$CONTENTSDIR/Resources"

	# Delete extraneous files
	find "$CONTENTSDIR" -depth -type d -name .git -exec rm -rf {} \;
	find "$CONTENTSDIR" \( -name .DS_Store -or -name update.rdf \) -exec rm -f {} \;

	# Sign
	if [ $SIGN == 1 ]; then
		/usr/bin/codesign --force --sign "$DEVELOPER_ID" \
			--requirements "$CODESIGN_REQUIREMENTS" \
			"$APPDIR"
	fi

	# Build disk image
	if [ $PACKAGE == 1 ]; then
		if [ $MAC_NATIVE == 1 ]; then
			rm -f "$DISTDIR/${PACKAGENAME}-${VERSION}.dmg"
			echo 'Creating Mac installer'
			"$CALLDIR/mac/pkg-dmg" --source "$STAGEDIR/$APPNAME.app" \
				--target "$DISTDIR/${PACKAGENAME}-${VERSION}.dmg" \
				--sourcefile --volname "$APPNAME" --copy "$CALLDIR/mac/DSStore:/.DS_Store" \
				--symlink /Applications:"/Drag Here to Install" > /dev/null
		else
			echo 'Not building on Mac; creating Mac distribution as a zip file'
			rm -f "$DISTDIR/${PACKAGENAME}-${VERSION}-mac.zip"
			cd "$STAGEDIR" && zip -rqX "$DISTDIR/${PACKAGENAME}-${VERSION}-mac.zip" $APPNAME.app
		fi
	fi
fi

# Win32
if [ $BUILD_WIN32 == 1 ]; then
	echo "Building ${PACKAGENAME}-win32"

	# Set up directory
	APPDIR="$STAGEDIR/${PACKAGENAME}-win32"
	rm -rf "$APPDIR"
	mkdir "$APPDIR"

	# Copy plugins
	if [ $BUNDLE_PLUGINS == 1 ]; then
		mkdir -p "$APPDIR/plugins"
		cp -r "$CALLDIR/plugins/win32/"* "$APPDIR/plugins/"
	fi

	# Merge xulrunner and relevant assets
	cp -R "$BUILDDIR/"* "$APPDIR"
	cp -r "$WIN32_RUNTIME_PATH" "$APPDIR/xulrunner"

	mv "$APPDIR/xulrunner/xulrunner-stub.exe" "$APPDIR/${APPNAME}.exe"

	# This used to be bug 722810, but that bug was actually fixed for Gecko 12. Now it's
	# unfortunately broken again.
	cp "$WIN32_RUNTIME_PATH/msvcp100.dll" \
	   "$WIN32_RUNTIME_PATH/msvcr100.dll" \
	   "$APPDIR/"

	# Delete extraneous files
	rm "$APPDIR/xulrunner/js.exe" "$APPDIR/xulrunner/redit.exe"
	find "$APPDIR" -depth -type d -name .git -exec rm -rf {} \;
	find "$APPDIR" \( -name .DS_Store -or -name update.rdf \) -exec rm -f {} \;
	find "$APPDIR" \( -name '*.exe' -or -name '*.dll' \) -exec chmod 755 {} \;

	if [ $PACKAGE == 1 ]; then
		if [ $WIN_NATIVE == 1 ]; then
			INSTALLER_PATH="$DISTDIR/${PACKAGENAME}-${VERSION}-setup.exe"

			# Add icon to xulrunner-stub
			"$CALLDIR/win/ReplaceVistaIcon/ReplaceVistaIcon.exe" "`cygpath -w \"$APPDIR/${APPNAME}.exe\"`" \
				"`cygpath -w \"$CALLDIR/assets/icons/default/main-window.ico\"`"

			echo 'Creating Windows installer'
			# Copy installer files
			cp -r "$CALLDIR/win/installer" "$BUILDDIR/win_installer"

			# Build and sign uninstaller
			"`cygpath -u \"$MAKENSISU\"`" /V1 "`cygpath -w \"$BUILDDIR/win_installer/uninstaller.nsi\"`"
			mkdir "$APPDIR/uninstall"
			mv "$BUILDDIR/win_installer/helper.exe" "$APPDIR/uninstall"

			# Sign $MODULE.exe, updater, and uninstaller
			if [ $SIGN == 1 ]; then
				"`cygpath -u \"$SIGNTOOL\"`" sign /a /d "$APPNAME" \
					/du "$SIGNATURE_URL" "`cygpath -w \"$APPDIR/${APPNAME}.exe\"`"
				"`cygpath -u \"$SIGNTOOL\"`" sign /a /d "$APPNAME Updater" \
					/du "$SIGNATURE_URL" "`cygpath -w \"$APPDIR/xulrunner/updater.exe\"`"
				"`cygpath -u \"$SIGNTOOL\"`" sign /a /d "$APPNAME Uninstaller" \
					/du "$SIGNATURE_URL" "`cygpath -w \"$APPDIR/uninstall/helper.exe\"`"
			fi

			# Stage installer
			INSTALLERSTAGEDIR="$BUILDDIR/win_installer/staging"
			mkdir "$INSTALLERSTAGEDIR"
			cp -R "$APPDIR" "$INSTALLERSTAGEDIR/core"

			# Build and sign setup.exe
			perl -pi -e "s/{{VERSION}}/$VERSION/" "$BUILDDIR/win_installer/defines.nsi"
			"`cygpath -u \"$MAKENSISU\"`" /V1 "`cygpath -w \"$BUILDDIR/win_installer/installer.nsi\"`"
			mv "$BUILDDIR/win_installer/setup.exe" "$INSTALLERSTAGEDIR"
			if [ $SIGN == 1 ]; then
				"`cygpath -u \"$SIGNTOOL\"`" sign /a /d "$APPNAME Setup" \
					/du "$SIGNATURE_URL" "`cygpath -w \"$INSTALLERSTAGEDIR/setup.exe\"`"
			fi

			# Compress application
			cd "$INSTALLERSTAGEDIR" && "`cygpath -u \"$EXE7ZIP\"`" a -r -t7z "`cygpath -w \"$BUILDDIR/app_win32.7z\"`" \
				-mx -m0=BCJ2 -m1=LZMA:d24 -m2=LZMA:d19 -m3=LZMA:d19  -mb0:1 -mb0s1:2 -mb0s2:3 > /dev/null

			# Compress 7zSD.sfx
			"`cygpath -u \"$UPX\"`" --best -o "`cygpath -w \"$BUILDDIR/7zSD.sfx\"`" \
				"`cygpath -w \"$CALLDIR/win/installer/7zstub/firefox/7zSD.sfx\"`" > /dev/null

			# Combine 7zSD.sfx and app.tag into setup.exe
			cat "$BUILDDIR/7zSD.sfx" "$CALLDIR/win/installer/app.tag" \
				"$BUILDDIR/app_win32.7z" > "$INSTALLER_PATH"

			# Sign ${PACKAGENAME}_setup.exe
			if [ $SIGN == 1 ]; then
				"`cygpath -u \"$SIGNTOOL\"`" sign /a /d "$APPNAME Setup" \
					/du "$SIGNATURE_URL" "`cygpath -w \"$INSTALLER_PATH\"`"
			fi

			chmod 755 "$INSTALLER_PATH"
		else
			echo 'Not building on Windows; only building zip file'
		fi
		cd "$STAGEDIR" && zip -rqX "$DISTDIR/${PACKAGENAME}-${VERSION}-win32.zip" "${PACKAGENAME}-win32"
	fi
fi

# Linux
if [ $BUILD_LINUX == 1 ]; then
	for arch in "i686" "x86_64"; do
		RUNTIME_PATH=`eval echo '$LINUX_'$arch'_RUNTIME_PATH'`

		# Set up directory
		echo "Building ${PACKAGENAME}-linux-$arch"
		APPDIR="$STAGEDIR/${PACKAGENAME}-linux-$arch"
		rm -rf "$APPDIR"
		mkdir "$APPDIR"

		# Copy plugins
		if [ $BUNDLE_PLUGINS == 1 ]; then
			mkdir -p "$APPDIR/plugins"
			cp -r "$CALLDIR/plugins/linux-$arch/"* "$APPDIR/plugins/"
		fi

		# Merge xulrunner and relevant assets
		cp -R "$BUILDDIR/"* "$APPDIR"
		cp -r "$RUNTIME_PATH" "$APPDIR/xulrunner"
		mv "$APPDIR/xulrunner/xulrunner-stub" "$APPDIR/$MODULE"
		chmod 755 "$APPDIR/$MODULE"

		# Delete extraneous files
		find "$APPDIR" -depth -type d -name .git -exec rm -rf {} \;
		find "$APPDIR" \( -name .DS_Store -or -name update.rdf \) -exec rm -f {} \;

		# Add run-$MODULE.sh
		cp "$CALLDIR/linux/run-$MODULE.sh" "$APPDIR/run-$MODULE.sh"

		# Move icons, so that updater.png doesn't fail
		mv "$APPDIR/xulrunner/icons" "$APPDIR/icons"

		if [ $PACKAGE == 1 ]; then
			# Create tar
			rm -f "$DISTDIR/${PACKAGENAME}-${VERSION}-linux-$arch.tar.bz2"
			cd "$STAGEDIR"
			tar -cjf "$DISTDIR/${PACKAGENAME}-${VERSION}-linux-$arch.tar.bz2" "${PACKAGENAME}-linux-$arch"
		fi
	done
fi

rm -rf $BUILDDIR
