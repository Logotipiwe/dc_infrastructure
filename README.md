# Инструкции к инфре
## Nginx ingress
### Обновление сертификата через certbot (вручную)
В консоли хост системы прогнать:
```shell
sudo certbot certonly --webroot
```
В webroot ввести `/kuber/infra/nginx/well-known`

Скопировать содержимое pem файлов в .crt и .key файлы

#### Wildcard domain cert
On server shell:
```shell
certbot certonly -d *.logotipiwe.ru --manual
```
Put txt record in timeweb dns.

### Certbot автоматический
На хосте:
```shell
apt-get update
apt-get install python3-pip -y
pip install certbot-dns-timeweb
```
Заполнить /ini
```
dns_timeweb_api_key = XXXXXXXXXXXXXXXXXXX
```

Сам сертбот:
```shell
certbot certonly --authenticator dns-timeweb \
  --dns-timeweb-credentials /etc/letsencrypt/timeweb-creds.ini \
  -d logotipiwe.ru -d *.logotipiwe.ru -n --expand
```

TODO - сделать это в докер контенйере локально

## n8n Setup
### Initial Database Setup
Before first deployment, create the n8n database in PostgreSQL:
```shell
-- Connect to pg container
docker exec -it pg psql -U postgres
```
```sql
-- Create database and user
CREATE DATABASE n8n;
GRANT ALL PRIVILEGES ON DATABASE n8n TO postgres;
\q
```

## Загрузка бэкапов из тг

- файл из тг распаковать в sql и загрузить руками в pgAdmin (в файл-менеджер). Если надо - увеличить лмимт размера файлва в настройках
- В нужной бд через Restore... выполнить этот файл