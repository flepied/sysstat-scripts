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

sadf -d -- -n ALL $sarfile > $temp2

cat > $temp3 <<EOF
$common
set title "Network"
set ylabel "packets/s"
$terminal
plot "< grep eth0 $temp2" using 3:5 with linespoints title "rxpck/s",  "< grep eth0 $temp2" using 3:6 with linespoints title "txpck/s", "< grep eth1 $temp2" using 3:5 with linespoints title "eth1 rxpck/s",  "< grep eth1 $temp2" using 3:6 with linespoints title "eth1 txpck/s"
$pause
EOF

gnuplot $temp3

# io.sh ends here
