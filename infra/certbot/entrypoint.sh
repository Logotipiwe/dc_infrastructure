#!/bin/bash

echo "Hi! Starting certbot container..."

cleanup() {
    echo "Received signal, shutting down gracefully..."
    pkill crond
    pkill tail
    exit 0
}
trap cleanup SIGTERM SIGINT

chmod +x /scripts/renew-certs.sh
echo "Running initial certificate renewal..."
sh /scripts/renew-certs.sh

echo "Setting up cron job for 6 AM daily..."
# TODO make monthly
(
  echo "DNS_WAIT_SECONDS=${DNS_WAIT_SECONDS}"
  echo "CERTBOT_OWNER_EMAIL=${CERTBOT_OWNER_EMAIL}"
  echo "DOMAINS=${DOMAINS}"
  echo "TIMEWEB_API_KEY=${TIMEWEB_API_KEY}"
  echo "*/5 * * * * /scripts/renew-certs.sh >> /var/log/cron.log 2>&1"
) | crontab -

echo "Starting cron daemon..."
crond
touch /var/log/cron.log
echo "Container started. Tailing cron log..."
tail -f /var/log/cron.log &

wait

