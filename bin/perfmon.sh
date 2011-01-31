#!/bin/bash
#---------------------------------------------------------------
# Project         : bin
# File            : perfmon.sh
# Version         : $Id: perfmon.sh,v 1.6 2008-03-14 17:54:48 fred Exp $
# Author          : Frederic Lepied
# Created On      : Wed May  9 17:19:40 2007
# Purpose         : 
#---------------------------------------------------------------

TARGETDIR=$HOME/perfdata
BINDIR=`dirname $0`
PATH=$PATH:/usr/sbin

usage() {
    echo "Usage: `basename $0` [-t|-v|-s|-p] -- <command> [<args>]" 1>&2
    echo "-t: run through time" 1>&2
    echo "-v: run through vtl" 1>&2
    echo "-s: run through sep" 1>&2
    echo "-S: run through strace" 1>&2
    echo "-o: run through oprofile" 1>&2
    echo "-p: run through tprofile_cl (broken)" 1>&2
    exit 1
}

if [ "$?" != 0 ];then
    usage
fi

VTUNE=
SEP=
TPROFILE=

while [ $1 != -- ]; do
    case $1 in	
	-t)
	    ;;
	-v)
	    if [ ! -x /opt/intel/vtune/bin/vtl ]; then
		echo "/opt/intel/vtune/bin/vtl not found. Aborting." !>&2
		exit 1
	    fi
	    VTUNE=1
	    ;;
	-s)
	    if !type -p sep>& /dev/null; then
		echo "sep command not found in path. Aborting." !>&2
		exit 1
	    fi
	    SEP=1
	    ;;
	-p)
	    if !type -p tprofile_cl>& /dev/null; then
		echo "tprofile_cl command not found in path. Aborting." !>&2
		exit 1
	    fi
	    TPROFILE=1
	    ;;
	-S)
	    if !type -p strace>& /dev/null; then
		echo "strace command not found in path. Aborting." !>&2
		exit 1
	    fi
	    STRACE=1
	    ;;
	-o)
	    if !type -p opcontrol>& /dev/null; then
		echo "opcontrol command not found in path. Aborting." !>&2
		exit 1
	    fi
	    OPROFILE=1
	    ;;
	*)
	    usage
	    ;;
    esac
    shift   # next flag
done

shift   # skip --

# now do the work

if [ ! -d "$TARGETDIR" ]; then
    mkdir -p "$TARGETDIR"
fi

rm -rf $TARGETDIR/*

if [ -n "$VTUNE" -o -n "$SEP" ]; then
    export VTUNE_GLOBAL_DIR=$TARGETDIR
    mkdir -p $VTUNE_GLOBAL_DIR/ISM
fi

export LC_ALL=C

# collect some prerun data
cp /proc/cpuinfo $TARGETDIR/
cp /proc/interrupts $TARGETDIR/interrupts.before

if type -p ifconfig >& /dev/null && type -p ethtool >& /dev/null; then
    for ifc in `ifconfig | grep ^eth | cut -f1 -d ' '`; do
	ethtool -S $ifc > $TARGETDIR/$ifc.before
    done
fi

# prepare a script to run the app
cat > $TARGETDIR/run_app.sh <<EOF
#!/bin/sh
EOF
echo -n "echo " >> $TARGETDIR/run_app.sh
for a in "$@"; do
    echo -n "\\\"$a\\\" " >> $TARGETDIR/run_app.sh
done
echo >> $TARGETDIR/run_app.sh
echo -n "exec " >> $TARGETDIR/run_app.sh
for a in "$@"; do
    echo -n "\"$a\" " >> $TARGETDIR/run_app.sh
done
echo >> $TARGETDIR/run_app.sh
chmod +x $TARGETDIR/run_app.sh

# collect bus utilization if on the path
if type -p pmu_kernel_26 > /dev/null 2>&1; then
    pmu_kernel_26 >& $TARGETDIR/pmu_kernel.out &
    PMUPID=$!
    echo "pmu started"
else
    PMUPID=
fi

# collect ioat dma data
if type -p collect-ioat-data.py > /dev/null 2>&1; then
    collect-ioat-data.py >& $TARGETDIR/dma.out&
    COLLECTPID=$!
else
    COLLECTPID=
fi

# start sar and iostat
if sar -V 2>&1|fgrep -q 'version 9'; then
    CONTINUOUS=
    P=w
else
    CONTINUOUS=0
    P=c
fi

rm -f $TARGETDIR/sar_data.dat
sar -bBqrRuv${P}W -P ALL -n DEV -n EDEV -I SUM -I XALL -o $TARGETDIR/sar_data.dat 1 $CONTINUOUS >& $TARGETDIR/sar.out &
SARPID=$!

rm -f $TARGETDIR/iostat_data.dat
iostat -t -d -k -x 1 >& $TARGETDIR/iostat_data.dat &
IOSTATPID=$!

echo "sar and iostat started"
sleep 1

rm -f $TARGETDIR/*.tb5
rm -f $TARGETDIR/vtl_view_*.txt
rm -f $TARGETDIR/vtl_module_date_time*.txt
rm -f $TARGETDIR/timeline_modules.txt

## collect with SEP
if [ -n "$SEP" ]; then
    export ctc_gen_log_path="$TARGETDIR"
    sep -start -sb 32768 -sd 0 -out $TARGETDIR/pat_vtune_data -ec    "INST_RETIRED.ANY":sa=14400000 ,  "CPU_CLK_UNHALTED.TOTAL_CYCLES":sa=14400000 ,  "BUS_DRDY_CLOCKS.THIS_AGENT":sa=100000 -app $TARGETDIR/run_app.sh 2>&1 | tee $TARGETDIR/output

## collect with VTune
elif [ -n "$VTUNE" ]; then
    /opt/intel/vtune/bin/vtl activity -c sampling -app $TARGETDIR/run_app.sh run 2>&1 | tee $TARGETDIR/output

## collect with Thread Profiler
elif [ -n "$TPROFILE" ]; then
    tprofile_cl $TARGETDIR/run_app.sh 2>&1 | tee $TARGETDIR/output

## collect with strace
elif [ -n "$STRACE" ]; then
    strace -c -f -o $TARGETDIR/strace.out $TARGETDIR/run_app.sh 2>&1 | tee $TARGETDIR/output

## collect using oprofile
#
# oprofile must be configured before the run with commands like the following:
# 
# opcontrol --image=<path to exe>
# opcontrol --event=CPU_CLK_UNHALTED:240300
# opcontrol --vmlinux=/boot/vmlinux-2.6.18-53.el5
# opcontrol --callgraph=30
# opcontrol -p kernel,thread
elif [ -n "$OPROFILE" ]; then
    opcontrol --reset
    opcontrol --start
    /usr/bin/time -p $TARGETDIR/run_app.sh 2>&1 | tee $TARGETDIR/output
    opcontrol --shutdown
    oparchive -o $TARGETDIR/oprofile-data
    
## collect time
else
    /usr/bin/time -p $TARGETDIR/run_app.sh 2>&1 | tee $TARGETDIR/output
fi

kill $SARPID
echo "sar stopped"
kill $IOSTATPID
echo "iostat stopped"

if [ -n "$PMUPID" ]; then
    kill $PMUPID
    echo "pmu stopped"
fi

if [ -n "$COLLECTPID" ]; then
    kill $COLLECTPID
    echo "ioat dma data collection stopped"
fi

# collect postrun data
cp /proc/interrupts $TARGETDIR/interrupts.after

if type -p ifconfig >& /dev/null && type -p ethtool >& /dev/null; then
    for ifc in `ifconfig | grep ^eth | cut -f1 -d ' '`; do
	ethtool -S $ifc > $TARGETDIR/$ifc.after
    done
fi

if [ -n "$VTUNE" -o -n "$SEP" ]; then
    for tb5 in `find $TARGETDIR -name '*.tb5'`; do  sfdump5 $tb5 -processes -cd , ; done > $TARGETDIR/vtl_view_process.txt
    for tb5 in `find $TARGETDIR -name '*.tb5'`; do  sfdump5 $tb5 -modules  -cd , ; done > $TARGETDIR/vtl_view_module.txt
fi

$BINDIR/gen.sh $TARGETDIR

# perfmon.sh ends here
