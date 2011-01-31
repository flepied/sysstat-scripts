#!/bin/sh
#---------------------------------------------------------------
# Module          : sysstat-scripts
# File            : process.sh
# Version         : $Id$
# Author          : Frederic Lepied
# Created On      : Thu Jun 29 20:39:09 2006
# Purpose         : 
#---------------------------------------------------------------

set -e

. `dirname $0`/commons

if [ -n "$V9" ]; then
    OPT=-w
else
    OPT=-c
fi

sadf -d -- $OPT $sarfile | $filter > $temp2

cat > $temp3 <<EOF
$common
set title "Process"
set ylabel "number/s"
$terminal
plot "$temp2" using 3:4 with linespoints title "proc/s"
$pause
EOF

gnuplot $temp3

# process.sh ends here
