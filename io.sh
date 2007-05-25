#!/bin/sh
#---------------------------------------------------------------
# Module          : sysstat-scripts
# File            : io.sh
# Version         : $Id$
# Author          : Frederic Lepied
# Created On      : Thu Jun 29 20:39:09 2006
# Purpose         : 
#---------------------------------------------------------------

set -e

. `dirname $0`/commons

sadf -d -- -b $sarfile > $temp2

cat > $temp3 <<EOF
$common
set title "I/O transactions"
set ylabel "Number"
$terminal
plot "$temp2" using 3:4 with linespoints title "tps", "$temp2" using 3:5 with linespoints title "rtps", "$temp2" using 3:6 with linespoints title "wtps"
$pause
EOF

gnuplot $temp3

# io.sh ends here
