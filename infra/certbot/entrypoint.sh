#!/bin/bash

echo "Hi! Starting certbot container..."

cleanup() {
    echo "Received signal, shutting down gracefully..."
    pkill crond
    pkill tail
    exit 0
}
trap cleanup SIGTERM SIGINT

cp /scripts/renew-certs.sh /usr/local/bin/renew-certs.sh
chmod +x /usr/local/bin/renew-certs.sh
echo "Running initial certificate renewal..."
sh /usr/local/bin/renew-certs.sh

echo "Setting up cron job for 6 AM daily..."
(
  echo "DNS_WAIT_SECONDS=${DNS_WAIT_SECONDS}"
  echo "CERTBOT_OWNER_EMAIL=${CERTBOT_OWNER_EMAIL}"
  echo "DOMAINS=${DOMAINS}"
  echo "TIMEWEB_API_KEY=${TIMEWEB_API_KEY}"
  echo "TELEGRAM_BOT_TOKEN=${TELEGRAM_BOT_TOKEN}"
  echo "TELEGRAM_CHAT_ID=${TELEGRAM_CHAT_ID}"
  echo "0 6 */5 * * sh /usr/local/bin/renew-certs.sh >> /var/log/cron.log 2>&1"
) | crontab -

echo "Starting cron daemon..."
crond
touch /var/log/cron.log
echo "Container started. Tailing cron log..."
tail -f /var/log/cron.log &

wait

