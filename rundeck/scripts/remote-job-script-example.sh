#!/bin/bash

REMOTE_USER="@option.SERVER_USERNAME@"
REMOTE_HOST="@option.SERVER_HOSTNAME@"
REMOTE_PASS="@option.SERVER_PASSWORD@"
REMOTE_PORT="@option.SERVER_PORT@"
SCRIPT_URL="@option.SCRIPT_URL@"
WORK_DIR="/tmp/rundeck"
SCRIPT_NAME="@option.SCRIPT_NAME@"


sshpass -p "$REMOTE_PASS" ssh -o StrictHostKeyChecking=no -p $REMOTE_PORT "$REMOTE_USER@$REMOTE_HOST" bash -s <<EOF

mkdir -p "$WORK_DIR"

curl -fsSL "$SCRIPT_URL" -o "$WORK_DIR/$SCRIPT_NAME"
if [ ! -s "$WORK_DIR/$SCRIPT_NAME" ]; then
  echo "Ошибка: Не удалось скачать скрипт."
  exit 1
fi

chmod +x "$WORK_DIR/$SCRIPT_NAME"
"$WORK_DIR/$SCRIPT_NAME"

rm -rf "$WORK_DIR"

EOF
