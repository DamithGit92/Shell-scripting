#!/bin/bash

# Author: Damith Bandara
# Version: 1.0
# Created Date: 25th-Jan 2023
# Purpose: Real Time CPU Utilization Monitoring

PATHS="/"
HOSTNAME=$(hostname)

CRITICAL=98
WARNING=90

# Inform Critical cituation to authorized person/s
CRITICALMail="youremailaddress@domain.com"
WARNINGMail="youremail@domain.in"

# Store logs
mkdir -p /var/log/cpuUtil
LOGFILE=/var/log/cpuUtil/cpusage-`date +%h%d%y`.log

touch $LOGFILE

for  path in $PATHS
do
    CPULOAD=`top -b -n 2 -d1 | grep "Cpu(s)" | tail -n1 | awk ;'{print $2}' | awk -F. '{print $1}'`

    if [ -n $WARNING -a -n $CRITICAL ]; then
        if [ "$CPULOAD" -ge "$WARNING" -a "$CPULOAD" -lt "$CRITICAL" ]; then
            echo "`date "+%F %H:%M:%S" ` WARNING - $CPULOAD on Host $HOSTNAME" >> $LOGFILE
            echo "Warning Cpuload $CPULOAD Host is $HOSTNAME" | mail -s "CPULOAD is Warning" $WARNINGMail
            exit 1
        elif [ "$CPULOAD" -ge "$CRITICAL" ]; then
            echo "`date "+%F %H:%M:%S" ` CRITICAL - $CPULOAD on Host $HOSTNAME" >> $LOGFILE
            echo "Critical Cpuload $CPULOAD Host is $HOSTNAME" | mail -s "CPULOAD is Critical" $CRITICALMail
            exit 2
        else
            echo "`date "+%F %H:%M:%S" ` OK - $CPULOAD on Host $HOSTNAME" >> $LOGFILE
            exit 0
        fi
    fi
done
