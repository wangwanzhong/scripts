#!/bin/bash
# chmod u+x /root/cron/cut_mongo_log.sh
# echo '59 23 * * * /root/cron/cut_mongo_log.sh' >> /var/spool/cron/root
################################

LOGFILE=/data/logs/mongodb/mongod.log

killall -SIGUSR1 mongod

DATE=$(date -d "7 days ago" +"%Y-%m-%d")

rm -f ${LOGFILE}.${DATE}T*-*-*

