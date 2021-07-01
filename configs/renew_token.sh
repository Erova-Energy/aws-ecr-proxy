#!/bin/sh

while sleep "${RENEW_TOKEN}"
do
  /auth_update.sh
  nginx -s reload
done
