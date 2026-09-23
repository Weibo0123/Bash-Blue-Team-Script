#!/bin/bash

PATTERN="Failed password"
ALERT_LOG="./alert.log"
YEAR=$(date +%Y)

while IFS= read -r line; do
    rhost=$(echo "$line" | grep -oP '(?<=from )\S+(?= port)')
    user=$(echo "$line" | awk -F'[= ]' '{print $(NF-5)}')
    month=$(echo "$line" | awk -F'[= ]' '{print $1}')
    month=$(date -d "$month 1" '+%m')
    data=$(echo "$line" | awk -F'[= ]' '{print $2}')
    time=$(echo "$line" | awk -F'[= ]' '{print $3}')
    message+="$YEAR-$month-$data $time rhost: $rhost, user: $user"$'\n'
done < <(journalctl -u ssh --no-pager | grep "$PATTERN")

echo -e "Invalid User Login Attempts detected:\n$message" | tee -a "$ALERT_LOG"
