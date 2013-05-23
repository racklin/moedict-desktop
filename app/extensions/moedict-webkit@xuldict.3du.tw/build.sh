#!/bin/bash

# Copyright (c) 2012  XULApp StarterKit racklin@gmail.com

CALLDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

PACKAGENAME="xulapp-starterkit-webapp-wrapper"
VERSION="1.1.1"

BUILDID=`date +%Y%m%d`
DISTDIR="$CALLDIR/dist"
BUILDDIR="$CALLDIR/build"

echo "Building Webapp Wrapper for XULApp StarterKit"

# Remove build directory
if [ ! -d "$BUILDDIR" ]; then mkdir -p "$BUILDDIR"; fi

# Copy app directory
cp -RH "$CALLDIR/webapp" "$BUILDDIR/"
cp -RH "$CALLDIR/chrome" "$BUILDDIR/"
cp -RH "$CALLDIR/defaults" "$BUILDDIR/"
cp "$CALLDIR/chrome.manifest" "$BUILDDIR/"
cp "$CALLDIR/install.rdf" "$BUILDDIR/"

# Make sure DISTDIR exists
if [ ! -d "$DISTDIR" ]; then mkdir -p "$DISTDIR"; fi

cd "$BUILDDIR" && zip -rqX "$DISTDIR/${PACKAGENAME}-${VERSION}.xpi" *

rm -rf $BUILDDIR
