#!/bin/sh
#---------------------------------------------------------------
# Module          : sysstat-scripts
# File            : cpu.sh
# Version         : $Id$
# Author          : Frederic Lepied
# Created On      : Thu Jun 29 20:39:09 2006
# Purpose         : 
#---------------------------------------------------------------

set -e

. `dirname $0`/commons

sadf -d -- -u $sarfile > $temp2

cat > $temp3 <<EOF
$common
set title "CPU usage"
set ylabel "Percent"
$terminal
#set style fill pattern 0 border
plot "$temp2" using 3:5 with boxes lt -1 title "user", "$temp2" using 3:6 with boxes lt -1 title "nice", "$temp2" using 3:7 with boxes lt -1 title "system", "$temp2" using 3:8 with boxes lt -1 title "iowait", "$temp2" using 3:9 with boxes lt -1 title "idle"
$pause
EOF

gnuplot $temp3

# io.sh ends here
