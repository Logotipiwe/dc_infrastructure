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
echo "*/10 * * * * /scripts/renew-certs.sh >> /var/log/cron.log 2>&1" | crontab -

echo "Starting cron daemon..."
crond
touch /var/log/cron.log
echo "Container started. Tailing cron log..."
tail -f /var/log/cron.log &

wait

