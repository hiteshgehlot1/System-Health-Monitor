#!/bin/bash

# ==========================================
# System Health Monitor
# ==========================================

mkdir -p logs alerts reports

LOGFILE="logs/health.log"
ALERTFILE="alerts/alert.log"
DATE=$(date +"%Y-%m-%d %H:%M:%S")

echo "============ System Health Monitor ============"

# ==========================================
# System Information
# ==========================================

echo
echo "Hostname:"
hostname

echo
echo "Uptime:"
uptime

# ==========================================
# CPU Information
# ==========================================

echo
echo "CPU Information:"
lscpu | grep "Model name\|CPU(s)"

echo
echo "CPU Usage:"
top -bn1 | grep "Cpu(s)"

# ==========================================
# Memory Information
# ==========================================

echo
echo "Memory Usage:"
free -h

# ==========================================
# Disk Information
# ==========================================

echo
echo "Disk Usage:"
df -h

# ==========================================
# Collect Metrics
# ==========================================

DISK=$(df / | awk 'NR==2 {gsub("%","",$5); print $5}')

MEMORY=$(free | awk '/Mem:/ {printf "%.0f", $3/$2*100}')

CPU=$(top -bn1 | awk '/Cpu\(s\)/ {print int($2)}')

# ==========================================
# Current Metrics
# ==========================================

echo
echo "========== Current Metrics =========="

echo "CPU Usage    : ${CPU}%"
echo "Memory Usage : ${MEMORY}%"
echo "Disk Usage   : ${DISK}%"

# ==========================================
# Logging
# ==========================================

echo
echo "Writing health log..."

echo "[$DATE] CPU=${CPU}% MEMORY=${MEMORY}% DISK=${DISK}%" >> "$LOGFILE"

echo
echo "Recent Health Logs:"
tail -n 10 "$LOGFILE"

# ==========================================
# Alerting
# ==========================================

echo
echo "Checking Alerts..."

ALERT_TRIGGERED=false

if [ "$DISK" -gt 85 ]; then
    echo "[$DATE] WARNING: Disk usage above 80% (${DISK}%)" >> "$ALERTFILE"
    echo "⚠ Disk usage high: ${DISK}%"
    ALERT_TRIGGERED=true
fi

if [ "$CPU" -gt 85 ]; then
    echo "[$DATE] WARNING: CPU usage above 85% (${CPU}%)" >> "$ALERTFILE"
    echo "⚠ CPU usage high: ${CPU}%"
    ALERT_TRIGGERED=true
fi

if [ "$MEMORY" -gt 85 ]; then
    echo "[$DATE] WARNING: Memory usage above 85% (${MEMORY}%)" >> "$ALERTFILE"
    echo "⚠ Memory usage high: ${MEMORY}%"
    ALERT_TRIGGERED=true
fi

if [ "$ALERT_TRIGGERED" = false ]; then
    echo "✓ No alerts detected."
fi

# ==========================================
# Summary
# ==========================================

echo
echo "============ Health Check Complete ============"
echo "Log File   : $LOGFILE"
echo "Alert File : $ALERTFILE"
echo "Timestamp  : $DATE"
