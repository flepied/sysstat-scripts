dist:
	cd ${HOME}; tar zcvf sysstat-scripts.tgz work/sysstat-scripts/*.sh work/sysstat-scripts/{commons,count.py,Makefile} bin/archive-perfmon.sh bin/gen.sh bin/perfmon.sh
