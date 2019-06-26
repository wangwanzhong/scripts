#!/bin/bash
# /root/cron/cut_nginx.sh
# echo '59 23 * * * /root/cron/cut_nginx.sh' >> /var/spool/cron/root
# chmod u+x /root/cron/cut_nginx.sh
# 

set -e


log_dir='/data/logs/nginx'
pid_file='/var/run/nginx.pid'


suffix=$(date +%Y%m%d)
suffix_del=$(date -d '-30 day' +%Y%m%d)
items=`find ${log_dir} -name '*.log'`
#items=`find ${log_dir} -maxdepth 1 -name '*.log'`

[ ! -d "${log_dir}/his" ] && mkdir "${log_dir}/his"

for i in ${items}
do
    name=`basename ${i}`
    mv ${i} ${log_dir}/his/${name}_${suffix}
    rm -f ${log_dir}/his/${name}_${suffix_del}
done

kill -USR1 `cat $pid_file`
