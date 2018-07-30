#!/bin/bash
#
### 
#  vim /root/cron/cut_php_log.sh
#  chmod u+x /root/cron/cut_php_log.sh
#  echo '59 23 * * * /root/cron/cut_php_log.sh' >> /var/spool/cron/root
#
#
#
set -e

PHP_PID=/var/run/php-fpm.pid
LOG_PATH=/dbdata/logs

CUT_TIME=$(date +"%Y%m%d")
DEL_TIME=$(date -d "7 days ago" +"%Y%m%d")


cut_php-fpm(){
    cd $LOG_PATH
    [ -f "php_error_log" ] && mv php_error_log php_error_${CUT_TIME}.log
    [ -f "php_slowlog" ] && mv php_slowlog php_slow_${CUT_TIME}.log
    kill -USR1 `cat ${PHP_PID}`
    rm -f php_error_${DEL_TIME}.log php_slow_${DEL_TIME}.log
}

cut_php-fpm
