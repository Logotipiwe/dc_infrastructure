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
  --test-cert \
  --agree-tos --email=${CERTBOT_OWNER_EMAIL} \
  --dns-timeweb-propagation-seconds=${DNS_WAIT_SECONDS}

# Copy certificates to host OS
echo "Copying certificates to host..."
mkdir -p /host-certs
if [ -d "/etc/letsencrypt/live/logotipiwe.ru" ]; then
  cp -L /etc/letsencrypt/live/logotipiwe.ru/privkey.pem /host-certs/
  cp -L /etc/letsencrypt/live/logotipiwe.ru/fullchain.pem /host-certs/
  echo "Certificates copied successfully to /host-certs/"
  ls -la /host-certs/
else
  echo "Certificate directory not found!"
  exit 1
fi

echo "Certificate renewal completed at $(date)" 