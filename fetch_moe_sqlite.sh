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

# Convert image to unicode using moedict
curl -O https://raw.github.com/g0v/moedict-epub/master/sym.txt
curl -O https://raw.github.com/g0v/moedict-epub/master/db2unicode.pl

echo ""
echo "Convert image to unicode by moedict-epub "
perl db2unicode.pl | sqlite3 development.unicode.sqlite3 2>&1 > /dev/null

# create index
if [ -f development.unicode.sqlite3 ]; then

    echo "Create dict indices"

    sqlite3 development.unicode.sqlite3 'CREATE INDEX "index_entries_title" ON "entries" ("title")'

    rm -f sym.txt
    rm -f db2unicode.pl
    rm -f development.sqlite3*

    mv development.unicode.sqlite3 development.sqlite3

fi

cd $CALLDIR


# idioms from tonyq
echo "Create idioms dictionary"

if [ ! -d $CALLDIR/app/extensions/{738ec4bc-6b50-11e2-a99c-68a86d302c50}/databases ]; then
  mkdir $CALLDIR/app/extensions/{738ec4bc-6b50-11e2-a99c-68a86d302c50}/databases
fi

cd $CALLDIR/app/extensions/{738ec4bc-6b50-11e2-a99c-68a86d302c50}/databases

sqlite3 idioms.sqlite3 < databases.schema

curl -O http://files.tonyq.org/data.sql

sqlite3 idioms.sqlite3 < data.sql

if [ -f idioms.sqlite3 ]; then

    rm data.sql

fi

cd $CALLDIR
