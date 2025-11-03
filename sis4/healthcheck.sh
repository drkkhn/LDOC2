if systemctl is-active --quiet password-manager; then
  echo "$(date): Service running" >> /var/log/service_health.log
else
  echo "$(date): Service stopped, restarting..." >> /var/log/service_health.log
  systemctl restart password-manager
fi
