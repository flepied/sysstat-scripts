#!/bin/sh
#---------------------------------------------------------------
# Project         : bin
# File            : img2html.sh
# Version         : $Id: img2html.sh,v 1.1 2008-03-03 18:42:36 fred Exp $
# Author          : Frederic Lepied
# Created On      : Mon Feb 11 09:41:13 2008
# Purpose         : 
#---------------------------------------------------------------

cat <<EOF
<!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML//EN">
<html> <head>
<title></title>
</head>

<body>
<h1></h1>
EOF

for f in "$@"; do
    echo "<img src=\"$f\">"
done

cat <<EOF
<hr>
<address></address>
<!-- hhmts start -->
<!-- hhmts end -->
</body> </html>
EOF

# img2html.sh ends here
