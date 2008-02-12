#!/bin/sh
#---------------------------------------------------------------
# Module          : sysstat-scripts
# File            : intr2.sh
# Version         : $Id$
# Author          : Frederic Lepied
# Created On      : Thu Jun 29 20:39:09 2006
# Purpose         : 
#---------------------------------------------------------------

set -e

. `dirname $0`/commons

dir=`dirname $sarfile`

sadf -d -- -I XALL $sarfile | $filter > $temp2

cat > $temp3 <<EOF
$common
set title "Interrupts"
set ylabel "number/s"
$terminal
EOF

echo -n "plot " >> $temp3

set `head -2048 $temp2 | cut -d \; -f 4 | fgrep -v -- '-1' | sort -n | uniq`

while [ -n "$*" ]; do
    irq=$1
    dev=`grep "^[ ]*$irq:" $dir/interrupts.after | sed 's/.* //'`
    echo -n " \"< grep ';$irq;[^;]*$' $temp2\" using 3:5 with linespoints title \"$dev irq $irq/s\"" >> $temp3
    shift
    if [ -n "$*" ]; then
	echo -n "," >> $temp3
    fi
done

cat >> $temp3 <<EOF

$pause
EOF

gnuplot $temp3

# intr2.sh ends here
