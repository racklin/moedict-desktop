#!/bin/bash

SITE="https://s3.amazonaws.com/xulapp/addons/xulapp-starterkit-addon-nodejs-0.8.17.xpi"

CALLDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [ ! -d $CALLDIR/app/extensions/nodejs@starterkit.xulapp.org ]; then
  mkdir $CALLDIR/app/extensions/nodejs@starterkit.xulapp.org
fi

cd $CALLDIR/app/extensions/nodejs@starterkit.xulapp.org

curl -O $SITE

unzip `basename $SITE`

rm -f `basename $SITE`

cd $CALLDIR

