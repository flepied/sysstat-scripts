#!/bin/bash

SCRIPTDIR=`dirname $0`/..

if [ -n "$1" ]; then
    TARGETDIR="$1"
else
    TARGETDIR=$HOME/perfdata
fi

if [ -n "$2" ]; then
    SCRIPTS="$2"
else
    SCRIPTS="$SCRIPTDIR/*.sh"
fi

echo -n "Generating graphs in $TARGETDIR"
for p in $SCRIPTS; do
    echo -n "."
    $p $TARGETDIR/sar_data.dat $TARGETDIR/`basename $p .sh`.png
done
echo done

cd $TARGETDIR
`dirname $0`/img2html.sh *.png > index.html
