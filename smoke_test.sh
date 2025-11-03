#!/usr/bin/env bash
set -e
echo "--- Smoke Test Start ---"

for pkg in curl wget git nginx psql ufw; do
  if command -v "$pkg" >/dev/null 2>&1; then
    echo "[OK] $pkg found"
  else
    echo "[FAIL] $pkg missing"
  fi
done

echo "--- Testing nginx ---"
if sudo systemctl start nginx 2>/dev/null; then
  curl -I http://localhost | head -n 1 || echo "[WARN] nginx not responding"
else
  echo "[WARN] nginx service unavailable in this environment"
fi

echo "--- Testing PostgreSQL client ---"
if command -v psql >/dev/null 2>&1; then
  psql --version
else
  echo "[FAIL] PostgreSQL client missing"
fi

echo "--- Smoke Test Complete ---"
