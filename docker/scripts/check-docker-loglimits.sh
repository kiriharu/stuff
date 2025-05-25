#!/bin/bash

echo "Проверка контейнеров на наличие ограничения max-size для логов..."
echo

found=0

for cid in $(docker ps -aq); do
    name=$(docker inspect --format '{{.Name}}' "$cid" | sed 's/^\/\(.*\)/\1/')
    max_size=$(docker inspect --format '{{ index .HostConfig.LogConfig.Config "max-size" }}' "$cid" 2>/dev/null)

    if [ -z "$max_size" ]; then
        echo "❌ Контейнер \"$name\" (ID: $cid) — НЕ установлен max-size"
        found=1
    else
        echo "✅ Контейнер \"$name\" (ID: $cid) — max-size=$max_size"
    fi
done

echo
if [ "$found" -eq 1 ]; then
    echo "⚠️ Некоторые контейнеры не имеют ограничений. Их нужно пересоздать после установки max-size /etc/docker/daemon.json"
else
    echo "✅ Все контейнеры настроены корректно."
fi
