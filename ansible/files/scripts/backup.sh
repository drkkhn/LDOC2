#!/bin/bash
DATE=$(date +%F_%H-%M-%S)
BACKUP_DIR="/var/backups"
SOURCE="/var/lib/vaultwarden"

mkdir -p "$BACKUP_DIR"
tar -czf "$BACKUP_DIR/vaultwarden_$DATE.tar.gz" -C / "${SOURCE#/}"
