#!/bin/bash

echo "Проверка лог-драйверов Docker-контейнеров..."
echo

containers=$(docker ps -aq)

if [ -z "$containers" ]; then
  echo "Нет запущенных контейнеров."
  exit 0
fi

for id in $containers; do
  name=$(docker inspect --format '{{ .Name }}' "$id" | sed 's/^\/\+//')
  short_id=$(echo "$id" | cut -c1-12)
  log_driver=$(docker inspect --format '{{ .HostConfig.LogConfig.Type }}' "$id")

  if [ "$log_driver" != "json-file" ]; then
    printf "%-30s %-20s %-20s 🚫 НЕ json-file\n" "$name" "$short_id" "$log_driver"
  else
    printf "%-30s %-20s %-20s ✅ OK\n" "$name" "$short_id" "$log_driver"
  fi
done
