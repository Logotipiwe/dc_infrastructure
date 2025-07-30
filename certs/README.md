### SSL directory
Files `logotipiwe.ru.crt` and `logotipiwe.ru.key` should be copied here by deploy script

To create local certs: 
```shell
openssl req -newkey rsa:2048 -nodes -keyout logotipiwe.ru.key -out logotipiwe.ru.csr && \
openssl x509 -signkey logotipiwe.ru.key -in logotipiwe.ru.csr -req -days 365 -out logotipiwe.ru.crt
```
