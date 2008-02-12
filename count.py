#!/usr/bin/python
#---------------------------------------------------------------
# Project         : sysstat-scripts
# File            : count.py
# Version         : $Id$
# Author          : Frederic Lepied
# Created On      : Fri May 25 10:04:08 2007
# Purpose         : replace a column by a count
#---------------------------------------------------------------

import sys
import string

col=int(sys.argv[1])
c=0
prev = None
for l in sys.stdin.readlines():
    a = l.split(';')
    cur = a[col]
    if cur != prev:
        if prev != None:
            c = c + 1
        prev = cur
    a[col] = str(c)
    sys.stdout.write(string.join(a, ';'))

# count.py ends here
