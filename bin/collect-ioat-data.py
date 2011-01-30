#!/usr/bin/python
#---------------------------------------------------------------
# Project         : ioat
# File            : collect-ioat-data.py
# Version         : $Id: collect-ioat-data.py,v 1.1 2008-03-03 22:51:46 fred Exp $
# Author          : Frederic Lepied
# Created On      : Sun Feb 17 15:07:55 2008
# Purpose         : collect IOAT DMA stats
#---------------------------------------------------------------

import signal
import os
import sys

DMADIR = '/sys/class/dma'
BT = 'bytes_transferred'
MC = 'memcpy_count'

def handler(a, b):
    signal.signal(signal.SIGALRM, handler)
    signal.alarm(1)
    
tick = 0
data = {}
old = {}

handler(0, 0)

try:
    while True:
        for f in os.listdir(DMADIR):
            for k in (BT, MC):
                key = (f, k)
                if tick != 0:
                    old[key] = data[key]
                data[key] = int(open(DMADIR + '/' + f + '/' + k).read(-1)[:-1])
            if tick != 0:
                sys.stderr.write('%d;%s;%d;%d\n' % (tick, f, data[(f, BT)] - old[(f, BT)], data[(f, MC)] - old[(f, MC)]))
        tick = tick + 1
        signal.pause()
except:
    pass

# collect-ioat-data.py ends here
