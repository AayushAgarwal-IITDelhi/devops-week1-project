#!/usr/bin/env bash
set -euo pipefail

webs=(
    "https://www.google.com"
    "https://www.youtube.com"
    "https://claude.ai/"
    "https://webmail.iitd.ac.in/"
    "http://localhost:8080"
)

webs_status=("down" "down" "down" "down" "down")

for i in "${!webs[@]}"; do
    if curl -s --max-time 10 "${webs[$i]}" > /dev/null 2>&1; then
        webs_status[$i]="up"
    else
        webs_status[$i]="down"
    fi
done

cat > /home/ubuntu/devops-week1-project/pages/index.html << EOF
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