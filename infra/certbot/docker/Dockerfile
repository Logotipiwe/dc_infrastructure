FROM certbot/certbot:latest

# Install required packages
RUN apk add --no-cache dcron curl

# Install certbot-dns-timeweb plugin
RUN pip install certbot-dns-timeweb

# Create directories for scripts and logs
RUN mkdir -p /scripts /var/log/letsencrypt

# Set working directory
WORKDIR /

# Default command will be overridden by docker-compose
CMD ["sh"] 