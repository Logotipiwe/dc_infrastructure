FROM certbot/certbot:latest

RUN apk add --no-cache dcron curl
RUN pip install certbot-dns-timeweb
#RUN mkdir -p /scripts /var/log/letsencrypt
WORKDIR /

ENTRYPOINT ["sh", "/entrypoint.sh"]