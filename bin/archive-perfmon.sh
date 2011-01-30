#!/bin/sh
#---------------------------------------------------------------
# Project         : bin
# File            : archive-perfmon.sh
# Version         : $Id: archive-perfmon.sh,v 1.3 2008-03-26 22:19:50 fred Exp $
# Author          : Frederic Lepied
# Created On      : Fri May 25 11:42:34 2007
# Purpose         : 
#---------------------------------------------------------------

BINSTORE=${BINSTORE=$HOME/results/binary-store}

if [ $# != 1 ]; then
    echo "usage: $0 <dir>" 1>&2
    exit 1
fi

mkdir -p "$1"
cp -aR ~/perfdata/* "$1"

if [ -d "$BINSTORE" -a -d "$1/oprofile-data" ]; then
    cd "$1/oprofile-data"
    set -x
    find . -type f | fgrep -v ./var/lib/oprofile | while read f;
    do
        sum=`md5sum "$f" | sed 's/ .*//'`
        if [ ! -r "$BINSTORE/$f/$sum" ]; then
	    mkdir -p "$BINSTORE/$f"
	    mv "$f" "$BINSTORE/$f/$sum"
	fi
	ln -f "$BINSTORE/$f/$sum" "$f" || ln -sf "$BINSTORE/$f/$sum" "$f"
    done
fi

# archive-perfmon.sh ends here
