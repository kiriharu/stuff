#!/bin/bash

VOLUME_PATH="/var/lib/docker/volumes"

echo "==========================================="
echo "  🐳 Неиспользуемые (висячие) образы Docker"
echo "==========================================="

docker images -f "dangling=true" --format "ID: {{.ID}}\tРепозиторий: {{.Repository}}\tТег: {{.Tag}}\tРазмер: {{.Size}}" | \
  (grep . || echo "Висячие образы не найдены.")

echo ""
echo "==========================================="
echo "  📦 Неиспользуемые (висячие) тома Docker"
echo "==========================================="

dangling_vols=$(docker volume ls -qf "dangling=true")

if [ -z "$dangling_vols" ]; then
    echo "Висячие тома не найдены."
else
    for vol in $dangling_vols; do
        vol_dir="${VOLUME_PATH}/${vol}/_data"
        if [ -d "$vol_dir" ]; then
            size=$(du -sh "$vol_dir" 2>/dev/null | cut -f1)
            echo "Том: $vol  |  Размер: $size"
        else
            echo "Том: $vol  |  ⚠ Не удалось определить размер (каталог не найден)"
        fi
    done
fi
