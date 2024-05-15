#!/bn/bash
set -e
nohup $TOMCAT_HOME/bin/startip.sh &
tail -f /dev/null