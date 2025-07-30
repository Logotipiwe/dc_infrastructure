#!/bin/sh
set -e

echo "[$(date)] Starting certificate generation/renewal process..."

# Function to send Telegram notification
send_telegram_notification() {
    local message="$1"
    if [ -n "$TELEGRAM_BOT_TOKEN" ] && [ -n "$TELEGRAM_CHAT_ID" ]; then
        echo "=== TELEGRAM NOTIFICATION DEBUG ==="
        echo "Tg Message: $message"
        curl -X POST "https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage" \
            -d chat_id="${TELEGRAM_CHAT_ID}" \
            -d text="🔐 Certbot: ${message}" \
            -d parse_mode="HTML"
        
        echo ""
        echo "--- END CURL OUTPUT ---"
        echo "Curl command completed"
        echo "=== END TELEGRAM DEBUG ==="
    else
        echo "❌ Telegram credentials not configured:"
        echo "   TELEGRAM_BOT_TOKEN: ${TELEGRAM_BOT_TOKEN:-'NOT SET'}"
        echo "   TELEGRAM_CHAT_ID: ${TELEGRAM_CHAT_ID:-'NOT SET'}"
    fi
}

# Function to send file to Telegram
send_telegram_file() {
    local file_path="$1"
    local caption="$2"
    
    if [ -n "$TELEGRAM_BOT_TOKEN" ] && [ -n "$TELEGRAM_CHAT_ID" ] && [ -f "$file_path" ]; then
        echo "=== TELEGRAM FILE UPLOAD DEBUG ==="
        echo "File: $file_path"
        echo "Caption: $caption"
        echo "File size: $(wc -c < "$file_path") bytes"
        echo "--- CURL OUTPUT ---"
        
        curl -X POST "https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendDocument" \
            -F chat_id="${TELEGRAM_CHAT_ID}" \
            -F document=@"$file_path" \
            -F caption="$caption"
        
        echo ""
        echo "--- END CURL OUTPUT ---"
        echo "File upload completed"
        echo "=== END FILE UPLOAD DEBUG ==="
    else
        echo "❌ Cannot send file:"
        echo "   TELEGRAM_BOT_TOKEN: ${TELEGRAM_BOT_TOKEN:-'NOT SET'}"
        echo "   TELEGRAM_CHAT_ID: ${TELEGRAM_CHAT_ID:-'NOT SET'}"
        echo "   File exists: $([ -f "$file_path" ] && echo 'YES' || echo 'NO')"
        echo "   File path: $file_path"
    fi
}

# Check if API key is provided
if [ -z "$TIMEWEB_API_KEY" ] || [ "$TIMEWEB_API_KEY" = "your_timeweb_api_key_here" ]; then
    error_msg="TIMEWEB_API_KEY not configured. Please set your API key in the .env file."
    echo "ERROR: $error_msg"
    send_telegram_notification "Error: $error_msg"
    return 1  # Return error but don't exit completely
fi

# Create credentials file
mkdir -p /etc/letsencrypt
echo "dns_timeweb_api_key = ${TIMEWEB_API_KEY}" > /etc/letsencrypt/timeweb-creds.ini
chmod 600 /etc/letsencrypt/timeweb-creds.ini

# Generate/renew certificates (always overwrites existing)
echo 'Generating/renewing certificates...'
if ! certbot certonly \
  --authenticator dns-timeweb \
  --dns-timeweb-credentials /etc/letsencrypt/timeweb-creds.ini \
  --email ${EMAIL} \
  --agree-tos \
  --non-interactive \
  --expand \
  --force-renewal \
  --cert-name all.logotipiwe.ru \
  -d ${DOMAINS}; then
    
    error_msg="Certificate generation failed. Check API key and domain configuration."
    echo "ERROR: $error_msg"
    send_telegram_notification "Error: $error_msg"
    return 1  # Return error but don't exit completely
fi

# Copy only the 2 essential files to nginx directory
echo 'Copying certificate files to nginx directory...'
mkdir -p /nginx-ssl
cp /etc/letsencrypt/live/all.logotipiwe.ru/fullchain.pem /nginx-ssl/
cp /etc/letsencrypt/live/all.logotipiwe.ru/privkey.pem /nginx-ssl/
echo 'Certificate files copied to nginx directory!'

# Send success notification
success_msg="SSL certificates successfully generated/renewed for ${DOMAINS}"
echo "$success_msg"
send_telegram_notification "$success_msg"

# Send certificate files to Telegram
if [ -n "$TELEGRAM_BOT_TOKEN" ] && [ -n "$TELEGRAM_CHAT_ID" ]; then
    echo 'Sending certificate files to Telegram...'
    send_telegram_file "/nginx-ssl/fullchain.pem" "🔐 Full certificate chain for ${DOMAINS}"
    send_telegram_file "/nginx-ssl/privkey.pem" "🔑 Private key for ${DOMAINS}"
    echo 'Certificate files sent to Telegram!'
else
    echo 'Telegram not configured, skipping file upload'
fi

echo "[$(date)] Certificate process completed" 