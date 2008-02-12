#!/bin/sh
#---------------------------------------------------------------
# Module          : sysstat-scripts
# File            : paging.sh
# Version         : $Id$
# Author          : Frederic Lepied
# Created On      : Thu Jun 29 20:39:09 2006
# Purpose         : 
#---------------------------------------------------------------

set -e

. `dirname $0`/commons

sadf -d -- -B $sarfile | $filter > $temp2

cat > $temp3 <<EOF
$common
set title "Paging"
set ylabel "KB/s"
$terminal
plot "$temp2" using 3:4 with linespoints title "pgpgin/s", "$temp2" using 3:5 with linespoints title "pgpgout/s"
$pause
EOF

gnuplot $temp3

# paging.sh ends here
