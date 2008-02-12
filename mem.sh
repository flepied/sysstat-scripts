#!/bin/sh
#---------------------------------------------------------------
# Module          : sysstat-scripts
# File            : mem.sh
# Version         : $Id$
# Author          : Frederic Lepied
# Created On      : Thu Jun 29 20:39:09 2006
# Purpose         : 
#---------------------------------------------------------------

set -e

. `dirname $0`/commons

sadf -d -- -r $sarfile | $filter > $temp2

cat > $temp3 <<EOF
$common
set title "Memory"
set ylabel "Allocated kilobytes"
$terminal
plot "$temp2" using 3:5 with linespoints title "kilobytes"
$pause
EOF

gnuplot $temp3

# mem.sh ends here
