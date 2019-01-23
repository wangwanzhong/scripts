#!/bin/bash
# /root/cron/cut_mongo_log.sh
# echo '59 23 * * * /root/cron/cut_mongo_log.sh' >> /var/spool/cron/root
################################

LOGFILE='/data/logs/mongodb/mongod.log /var/log/mongo/mongo.log'

killall -SIGUSR1 mongod

DATE=$(date -d "7 days ago" +"%Y-%m-%d")

for log in ${LOGFILE}
do
    rm -f "${log}.${DATE}T*-*-*"
done
