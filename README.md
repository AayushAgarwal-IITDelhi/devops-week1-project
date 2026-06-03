# devops-week1-project

A self-hosted status page that monitors services every minute and serves a live HTML page via nginx.

## Services monitored

- https://www.google.com
- https://www.youtube.com
- https://claude.ai/
- https://webmail.iitd.ac.in/
- http://localhost:8080

## Setup (Ubuntu VM)

We have set up such that repo is mounted to `~/devops-week1-project`.

```bash
# Copy systemd units
sudo cp systemd/server.service /etc/systemd/system/
sudo cp systemd/status.service /etc/systemd/system/
sudo cp systemd/status.timer /etc/systemd/system/

# Reload and start
sudo systemctl daemon-reload
sudo systemctl enable --now server.service
sudo systemctl enable --now status.timer

# Run status check once immediately
sudo systemctl start status.service

# Set up nginx
sudo cp nginx/status.conf /etc/nginx/sites-enabled/
sudo systemctl restart nginx
```

## Verify

```bash
curl http://localhost:8000        # Python server
curl http://localhost             # nginx proxy
journalctl -u status.service      # check logs
```
![Project Screenshot](Screenshot_Project_Week1.png)