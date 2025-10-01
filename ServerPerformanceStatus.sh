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

# Disk usage (total and per mountpoint)
echo "Disk Usage:"
lsblk -b -d -o SIZE,NAME | awk '
NR>1 { total+=$1; disks[$2]=$1 }
END {
  # get used space from df (excluding tmpfs/devtmpfs/overlay)
  cmd="df -B1 -x tmpfs -x devtmpfs -x overlay --total | awk \"/total/{print \\$2,\\$3,\\$4}\""
  cmd | getline line
  split(line, vals, " ")
  used=vals[2]; free=vals[3]

  printf "  Used: %.2f GB  Free: %.2f GB  Total: %.2f GB (across all physical disks)\n", \
         used/1024/1024/1024, free/1024/1024/1024, total/1024/1024/1024
}'

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

