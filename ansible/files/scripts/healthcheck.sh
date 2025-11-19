#!/bin/bash
SERVICE="password-manager"
LOG="/var/log/service_health.log"

if ! docker ps | grep -q "$SERVICE"; then
    echo "$(date): Service stopped, restarting..." >> "$LOG"
    docker restart "$SERVICE"
else
    echo "$(date): Service OK" >> "$LOG"
fi
