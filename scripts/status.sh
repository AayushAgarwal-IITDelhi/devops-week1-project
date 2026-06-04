#!/usr/bin/env bash
set -euo pipefail

#env variables
source "$(dirname "$0")/../.env"

#webs to check

webs=(
    "https://www.google.com"
    "https://www.youtube.com"
    "https://claude.ai/"
    "https://webmail.iitd.ac.in/"
    "http://localhost:8080"
)

webs_status=("down" "down" "down" "down" "down")

#check status of webs

for i in "${!webs[@]}"; do
    if curl -s --max-time 10 "${webs[$i]}" > /dev/null 2>&1; then
        webs_status[$i]="up"
    else
        webs_status[$i]="down"
    fi
done

#update last status on html page

HTML="$(dirname "$0")/../pages/index.html"

cat > "$HTML" << EOF
<html>
<title>Status Logs</title>
<body>
$(
for i in "${!webs[@]}"; do
    echo "<p>${webs[$i]}: ${webs_status[$i]}</p>"
done
)
</body>
</html>
EOF

#send slack notification if status has changed

LOG="$(dirname "$0")/../pages/last_status.txt"

for i in "${!webs[@]}"; do
    link="${webs[$i]}"
    last=$(awk -v site="$link" '$1 == site {print $2}' "$LOG" 2>/dev/null || echo "down")
    if [[ "${webs_status[$i]}" == "down" && "$last" == "up" ]]; then
        curl -s -X POST -H 'Content-type: application/json' --data "{\"text\":\"$link is down.\"}" "$SLACK_WEBHOOK"
    fi
done

#update status in last_status.txt

for i in "${!webs[@]}"; do
    echo "${webs[$i]} ${webs_status[$i]}"
done > "$LOG"