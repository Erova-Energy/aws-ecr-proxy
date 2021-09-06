#!/bin/sh

while sleep "${RENEW_TOKEN}"
do
  /auth_update.sh
  nginx -t && nginx -s reload
done
