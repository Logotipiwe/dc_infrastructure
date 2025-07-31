#!/bin/bash

echo "Starting certificate renewal process..."

mkdir -p /etc/letsencrypt
echo "dns_timeweb_api_key = ${TIMEWEB_API_KEY}" > /etc/letsencrypt/timeweb-creds.ini
chmod 600 /etc/letsencrypt/timeweb-creds.ini

# uncomment --test-cert locally
certbot certonly --authenticator dns-timeweb \
  --dns-timeweb-credentials /etc/letsencrypt/timeweb-creds.ini \
  --cert-name logotipiwe.ru \
  -d ${DOMAINS} -n --expand \
  --force-renewal \
  --agree-tos --email=${CERTBOT_OWNER_EMAIL} \
  --dns-timeweb-propagation-seconds=${DNS_WAIT_SECONDS} # --test-cert

# Copy certificates to host OS
echo "Copying certificates to host..."
mkdir -p /host-certs
if [ -d "/etc/letsencrypt/live/logotipiwe.ru" ]; then
  cp -L /etc/letsencrypt/live/logotipiwe.ru/privkey.pem /host-certs/
  cp -L /etc/letsencrypt/live/logotipiwe.ru/fullchain.pem /host-certs/
  echo "Certificates copied successfully to /host-certs/"
  ls -la /host-certs/
  
  echo "Sending certificates via Telegram..."
  curl -F chat_id="${TELEGRAM_CHAT_ID}" -F document=@"/etc/letsencrypt/live/logotipiwe.ru/privkey.pem" https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendDocument
  curl -F chat_id="${TELEGRAM_CHAT_ID}" -F document=@"/etc/letsencrypt/live/logotipiwe.ru/fullchain.pem" https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendDocument
  echo "Certificates sent to Telegram"
else
  echo "Certificate directory not found!"
  exit 1
fi

echo "Certificate renewal completed at $(date)" 