#!/bin/sh
#---------------------------------------------------------------
# Project         : sysstat-scripts
# File            : sock.sh
# Version         : $Id$
# Author          : Frederic Lepied
# Created On      : Tue Oct  9 09:03:48 2007
# Purpose         : 
#---------------------------------------------------------------

set -e

. `dirname $0`/commons

sadf -d -- -n SOCK $sarfile | $filter > $temp2

cat > $temp3 <<EOF
$common
set title "Sockets"
set ylabel "number"
$terminal
plot "$temp2" using 3:5 with linespoints title "tcpsck", "$temp2" using 3:6 with linespoints title "udpsck", "$temp2" using 3:7 with linespoints title "rawsck", "$temp2" using 3:8 with linespoints title "ip-frag"
$pause
EOF

# "$temp2" using 3:4 with linespoints title "totsck",

gnuplot $temp3

# sock.sh ends here
