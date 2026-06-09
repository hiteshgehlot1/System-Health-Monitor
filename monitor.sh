#!/bin/bash

echo "============ System Health Monitor =========="

echo "Hostname: "
hostname

echo
echo "Uptime: "
uptime


############ CPU Information ##############

echo
echo "CPU Information: "

lscpu | grep "Model name\|CPU MHz\|CPU(s)"

echo
echo "CPU Usage: "
top -bn1 | grep "Cpu(s)"

########## Memory Usage ###############

echo
echo "Memory Usage:"
free -h

########## Disk Usage ###############
echo
echo "Disk Usage: "
df -h


########## Log Information ##############

echo
echo "Recent System Logs: "

LOGFILE="logs/health.log"
DATE=$(date +"%Y-%m-%d %H:%M:%S")

echo "[$DATE] System health check performed." >> $LOGFILE

cat logs/health.log