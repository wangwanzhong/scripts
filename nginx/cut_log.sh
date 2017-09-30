#!/bin/bash
#
###
#  description: cut nginx and php log 
#  run at: 23:59 every day
#
#
#
#

CUT_TIME=$(date +"%Y%m%d")
DEL_TIME=$(date -d "7 days ago" +"%Y%m%d")


cut_nginx(){
    LOG_PATH=/dbdata/logs/nginx/
    PID_FILE=/var/run/nginx.pid

    log_files=`/bin/find ${LOG_PATH} -name *.log`

    for i in ${log_files}
    do
        /bin/mv ${i} ${i}_${CUT_TIME}.bak
        
        rm -f ${i}_${DEL_TIME}.bak
    done
    
    kill -USR1 `cat ${PID_FILE}`

}

cut_php-fpm(){
    PHP_PID=/var/run/php-fpm.pid
    LOG_PATH=/dbdata/logs
    cd $LOG_PATH
    mv php_error_log php_error_${CUT_TIME}.log
    mv php_slowlog php_slow_${CUT_TIME}.log
    kill -USR1 `cat ${PHP_PID}`
    rm -f php_error_${DEL_TIME}.log php_slow_${DEL_TIME}.log

}

cut_nginx
cut_php-fpm
