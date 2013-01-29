#!/bin/bash

SITE="http://kcwu.csie.org/~kcwu/tmp/moedict/development.sqlite3.bz2"

CALLDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [ ! -d $CALLDIR/app/extensions/{213aaa92-69e7-11e2-83c0-68a86d302c50}/databases ]; then
  mkdir $CALLDIR/app/extensions/{213aaa92-69e7-11e2-83c0-68a86d302c50}/databases
fi
cd $CALLDIR/app/extensions/{213aaa92-69e7-11e2-83c0-68a86d302c50}/databases

curl -O $SITE

if [ -f development.sqlite3 ]; then
    rm -f development.sqlite3;
fi

bzip2 -d development.sqlite3.bz2

# create index
if [ -f development.sqlite3 ]; then

    echo "Create dict indices"

    sqlite3 development.sqlite3 'CREATE INDEX "index_entries_title" ON "entries" ("title")'
fi

cd $CALLDIR

