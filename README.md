TODO
- Запуск всего одной командой
- Узнать где лежить волюм и как его задеплоить
- Узнать про видимость под друг друга (для подключения бд)

You can use a .env file. There you must set a COMPOSE_FILE environment variable and set it to COMPOSE_FILE=a.yaml:b.yaml:c.yaml

Now you can run all compose files with docker-compose up

projekt/
.env
a.yaml
b.yaml
c.yaml