sysstat-scripts is a set of scripts to run wokloads and collect
system informations while they run.

For example, here is the way to launch a benchmark: ::

 ~/sysstat-scripts/bin/perfmon.sh -t -- <command and arguments to launch the benchmark>

The resulting files will be in the ~/perfdata directory.

To archive the files use: ::

 ~/sysstat-scripts/bin/archive-perfmon.sh <path to store the files>

To see the results, just load the index.html file in your browser.

FAQ

1. if your workload is running forever, you can use the wait.sh
script to just run for a certain amount of time. For example, to run
for 30 seconds: ::

 ~/sysstat-scripts/bin/perfmon.sh -t -- ~/sysstat-scripts/bin/wait.sh 30
