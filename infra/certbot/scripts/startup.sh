#!/bin/sh
set -e

echo 'Copying certificate generation script...'
cp /scripts/renew-certs.sh /usr/local/bin/renew-certs.sh
chmod +x /usr/local/bin/renew-certs.sh

echo 'Running initial certificate generation...'
if /usr/local/bin/renew-certs.sh; then
  echo 'Initial certificate generation successful'
else
  echo 'Initial certificate generation failed, but continuing to setup cron...'
fi

echo 'Setting up cron job for certificate generation daily at 6 AM...'
echo '0 6 * * * /usr/local/bin/renew-certs.sh >> /var/log/letsencrypt/renewal.log 2>&1' | crontab -

echo 'Starting cron daemon in background...'
crond

echo 'Creating renewal log file if it does not exist...'
touch /var/log/letsencrypt/renewal.log

echo 'Container is ready. Following renewal log file...'
echo 'All certificate renewal activity will appear below:'
echo '================================================='
tail -f /var/log/letsencrypt/renewal.log 