# Инструкции к инфре
## Nginx ingress
### Обновление сертификата через certbot
В консоли хост системы прогнать:
```shell
sudo certbot certonly --webroot
```
В webroot ввести `/kuber/infra/nginx/well-known`

Todo: 
- Изучить renew
- Автоматический ввод webroot в команду certbot