#!/bin/sh
#---------------------------------------------------------------
# Module          : sysstat-scripts
# File            : swap.sh
# Version         : $Id$
# Author          : Frederic Lepied
# Created On      : Thu Jun 29 20:39:09 2006
# Purpose         : 
#---------------------------------------------------------------

set -e

. `dirname $0`/commons

sadf -d -- -W $sarfile | $filter > $temp2

cat > $temp3 <<EOF
$common
set title "Swap"
set ylabel "KB"
$terminal
plot "$temp2" using 3:5 with linespoints title 'Swap'
$pause
EOF

gnuplot $temp3

# swap.sh ends here
