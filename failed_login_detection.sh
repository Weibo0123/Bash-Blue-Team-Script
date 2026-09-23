#!/bin/bash

PATTERN="Failed password"

while IFS= read -r line; do
    rhost=$(echo "$line" | grep -oP '(?<=from )\S+(?= port)')
    user=$(echo "$line" | awk -F'[= ]' '{{print $(NF-5)}}')
    message+="rhost: $rhost, user: $user"$'\n'
done < <(journalctl -u ssh --no-pager -o cat | grep "$PATTERN")

echo -e "Invalid User Login Attempts detected:\n$message"