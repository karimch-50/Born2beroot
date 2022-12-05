#!/bin/bash

echo "#Architecture: $(uname -a)"

echo "#CPU physical : $(grep "physical id" /proc/cpuinfo | sort -u | wc -l)"

echo "#vCPU : $(grep "processor" /proc/cpuinfo | sort -u | wc -l)"

TotlMem=$(free -m | awk 'NR==2 {printf("%d", $2 - $4)}')
UsedMem=$(free -m | awk 'NR==2 {printf("%d", $2)}')
echo "#Memory Usage: $TotlMem/$UsedMem""MB $(awk -v a=$TotlMem -v b=$UsedMem '{printf("(%.2f%%)", (a * 100) / b)}' <<< /dev/null)"

TotlDisk=$(df -Bg --total | awk 'NR==14 {print $2}')
UsedDisk=$(df -Bm --total | awk 'NR==14 {print substr($3, 0, length($3) - 1)}')
Persent=$(df --total | awk 'NR==14 {print $5}')
echo "#Disk Usage: $UsedDisk""/$TotlDisk""b ($Persent)"

CPULoad=$(top -bn1 | grep "%Cpu" | awk -F ',' '{print $4}' | awk '{printf("%.1f%%", 100 - $1)}')
echo "#CPU load: $CPULoad"

echo "#Last boot: $(who -b | awk '{printf("%s %s", $3, $4)}')"

echo "#LVM use: $(lsblk | awk '{print $6}' | awk -v s=0 '/lvm/{++s} END{print s != 0 ? "yes" : "no"}')"

echo "#Connections TCP : $(ss -t | grep "ESTAB" | wc -l) ESTABLISHED"

echo "#User log: $(who | wc -l)"
echo "#Network: IP $(hostname -I) ($(ip link | grep "link/ether" | awk '{print $2}'))"
echo "#Sudo : $(ls /var/log/sudo/*/* | wc -l) cmd"