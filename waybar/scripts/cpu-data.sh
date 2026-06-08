#!/usr/bin/env bash
CPU=$(awk '{u=$2+$4;t=$2+$4+$5;if(NR==1){u1=u;t1=t}else print int(100*(u-u1)/(t-t1))}' \
<(grep '^cpu ' /proc/stat) <(sleep 1; grep '^cpu ' /proc/stat))

HWMON=$(grep -rl 'coretemp' /sys/class/hwmon/hwmon*/name 2>/dev/null | grep -o '/sys/class/hwmon/hwmon[0-9]*')
TEMP=$(( $(cat "$HWMON/temp1_input") / 1000 ))

if [ "$TEMP" -ge 80 ]; then CLASS="critical"; else CLASS=""; fi
echo "{\"text\": \"${CPU}% ${TEMP}°C\", \"class\": \"$CLASS\"}"