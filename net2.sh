#!/bin/sh
#---------------------------------------------------------------
# Module          : sysstat-scripts
# File            : net.sh
# Version         : $Id$
# Author          : Frederic Lepied
# Created On      : Thu Jun 29 20:39:09 2006
# Purpose         : 
#---------------------------------------------------------------

set -e

. `dirname $0`/commons

sadf -d -- -n ALL $sarfile | $filter > $temp2

cat > $temp3 <<EOF
$common
set title "Network"
set ylabel "Bytes/s"
$terminal
EOF

echo -n "plot " >> $temp3

set `head -50 $temp2 | cut -d \; -f 4 | grep '^eth' | sort | uniq`

while [ -n "$*" ]; do
    ifc=$1
    echo -n " \"< grep $ifc $temp2\" using 3:7 with linespoints title \"$ifc rxbyt/s\",  \"< grep $ifc $temp2\" using 3:8 with linespoints title \"$ifc txbyt/s\" " >> $temp3
    shift
    if [ -n "$*" ]; then
	echo -n "," >> $temp3
    fi
done

cat >> $temp3 <<EOF

$pause
EOF

gnuplot $temp3

# net2.sh ends here
