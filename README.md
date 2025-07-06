# Инструкции к инфре
## Nginx ingress
### Обновление сертификата через certbot
В консоли хост системы прогнать:
```shell
sudo certbot certonly --webroot
```
В webroot ввести `/kuber/infra/nginx/well-known`

Nice to have: 
- Изучить renew
- Автоматический ввод webroot в команду certbot

### Wildcard domain cert
On server shell:
```shell
certbot certonly -d *.logotipiwe.ru --manual
```
Put txt record in timeweb dns.

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