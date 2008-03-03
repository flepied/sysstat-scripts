#!/bin/sh
#---------------------------------------------------------------
# Project         : sysstat-scripts
# File            : load.sh
# Version         : $Id$
# Author          : Frederic Lepied
# Created On      : Mon Mar  3 15:55:28 2008
# Purpose         : 
#---------------------------------------------------------------

set -e

. `dirname $0`/commons

sadf -d -- -q $sarfile | $filter > $temp2

cat > $temp3 <<EOF
$common
set title "Load"
set ylabel "Number of processes"
$terminal
plot "$temp2" using 3:6 with linespoints title "active processes"
$pause
EOF

gnuplot $temp3

# load.sh ends here
