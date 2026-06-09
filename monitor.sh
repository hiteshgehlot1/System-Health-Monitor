#!/bin/bash

echo "============ System Health Monitor =========="

echo "Hostname: "
hostname

echo
echo "Uptime: "
uptime


echo "CPU Information: "

lscpu | grep "Model name\|CPU MHz\|CPU(s)"

echo "CPU Usage: "
top -bn1 | grep "Cpu(s)"

