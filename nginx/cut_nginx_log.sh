#!/bin/bash
#
### 
#  vim /root/cron/cut_nginx_log.sh
#  chmod u+x /root/cron/cut_nginx_log.sh
#  echo '59 23 * * * /root/cron/cut_nginx_log.sh' >> /var/spool/cron/root
#
#
#

set -e

LOG_PATH=/dbdata/logs/nginx/
PID_FILE=/var/run/nginx.pid

CUT_TIME=$(date +"%Y%m%d")
DEL_TIME=$(date -d "7 days ago" +"%Y%m%d")


cut_nginx(){
    log_files=`/bin/find ${LOG_PATH} -name '*.log'`

    for i in ${log_files}
    do
        [ ! -d "${LOG_PATH%/}/history" ] && mkdir "${LOG_PATH%/}/history"
        /bin/mv ${i} ${LOG_PATH%/}/history/$(basename ${i})_${CUT_TIME}.bak
        
        rm -f ${LOG_PATH%/}/history/$(basename ${i})_${DEL_TIME}.bak
    done
    
    kill -USR1 `cat ${PID_FILE}`

}

cut_nginx
