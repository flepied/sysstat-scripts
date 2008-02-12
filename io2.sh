#!/bin/sh
#---------------------------------------------------------------
# Module          : sysstat-scripts
# File            : io2.sh
# Version         : $Id$
# Author          : Frederic Lepied
# Created On      : Thu Jun 29 20:39:09 2006
# Purpose         : 
#---------------------------------------------------------------

set -e

. `dirname $0`/commons

sadf -d -- -b $sarfile | $filter > $temp2

cat > $temp3 <<EOF
$common
set title "I/O rate"
set ylabel "KB/s"
$terminal
plot "$temp2" using 3:(\$7/2) with linespoints title "bread/s", "$temp2" using 3:(\$8/2) with linespoints title "bwrtn/s"
$pause
EOF

gnuplot $temp3

# io.sh ends here
