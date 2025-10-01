#!/bin/bash

echo "================= System Information ================="
echo "Hostname       : $(hostname)"
echo "Uptime         : $(uptime -p)"
echo "Kernel Version : $(uname -r)"
echo "------------------------------------------------------"

# CPU usage
echo "CPU Usage:"
mpstat 1 1 | awk '/Average/ && $2 ~ /all/ {printf "  User: %.1f%%  System: %.1f%%  Idle: %.1f%%\n", $3, $5, $12}'
echo "------------------------------------------------------"

# Memory usage
echo "Memory Usage:"
free -h | awk 'NR==2{printf "  Used: %s  Free: %s  Total: %s\n", $3,$4,$2}'
echo "------------------------------------------------------"

# Top 5 CPU-consuming processes
echo "Top 5 Processes by CPU usage:"
ps -eo pid,comm,%cpu,%mem --sort=-%cpu | head -n 6
echo "------------------------------------------------------"

# Top 5 Memory-consuming processes
echo "Top 5 Processes by Memory usage:"
ps -eo pid,comm,%cpu,%mem --sort=-%mem | head -n 6
echo "======================================================"

