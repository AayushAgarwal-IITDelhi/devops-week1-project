webs=(
    "https://www.google.com"
    "https://www.youtube.com"
    "https://claude.ai/"
    "https://webmail.iitd.ac.in/"
    "http://localhost:8080"
)

webs_status=("down" "down" "down" "down" "down")

for i in "${!webs[@]}"; do
    link=${webs[$i]}
    curl -s --max-time 5 "$link" > /dev/null 2>&1
    if [ $? -ne 0 ]; then
        webs_status[$i]="down"
    else
        webs_status[$i]="up"   
    fi
done

cat > index.html << EOF
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