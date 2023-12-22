#!/bin/bash

set -e
GREEN=$'\e[0;32m'
RED=$'\e[0;31m'
NC=$'\e[0m'

echo "Проверяем вашу работу"
echo "..."; sleep 2

# Проверка запущенных контейнеров Docker (web, redis, postgres)
for service in web redis postgres
do
    if [ -z $(docker-compose ps -q $service) ] || [ -z $(docker ps -q --no-trunc | grep $(docker-compose ps -q $service)) ]; then
        echo "${RED}Контейнер с $service не запущен${NC}"
        exit 1
    else
        echo "${GREEN}Контейнер $service запущен${NC}"
        echo "..."; sleep 1
    fi
done

# Проверка наличия именованного тома
if [ -z "$(docker volume ls | grep mine)" ]; then
    echo "${RED}Том для данных не найден${NC}"
    exit 1
else
    echo "${GREEN}Том для данных найден${NC}"
    echo "..."; sleep 1
fi

# Проверка монтирования тома в postgres
if ! $(docker inspect -f '{{ (index .Mounts) }}' $(docker-compose ps -q postgres) 2> /dev/null | grep "/var/lib/postgresql/data" &> /dev/null); then
    echo "${RED}Том для данных не смонтирован${NC}"
    exit 1
else
    echo "${GREEN}Том для данных смонтирован по необходимому пути${NC}"
    echo "..."; sleep 1
fi

# Проверка того, что контейнер web слушает порт 5000
if ! $(cat < /dev/null > /dev/tcp/127.0.0.1/5000) 2> /dev/null; then
    echo "${RED}Контейнер не прослушивает порт 5000${NC}"
    exit 1
else
    echo "${GREEN}Контейнер прослушивает запросы на порту 5000${NC}"
    echo "..."; sleep 1
fi

# Проверка возможности использования curl и получения корректного ответа

string="This page has been viewed"
if [[ $(curl -s "http://127.0.0.1:5000") == *"$string"* ]]; then
    echo "${GREEN}Ответ от приложения верный${NC}"
else
    echo "${RED}Ответ от приложения неверный:${NC}"
    echo "$(curl -vs http://127.0.0.1:5000/)"
    exit 1
fi
