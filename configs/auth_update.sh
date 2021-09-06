#!/bin/sh
nx_conf=/etc/nginx/nginx.conf

if [ -z "${DOCKER_REGISTRY_VERSION}" ]; then
  DOCKER_REGISTRY_VERSION=2
elif [ "${DOCKER_REGISTRY_VERSION}" != "1" ] && [ "${DOCKER_REGISTRY_VERSION}" != "2" ]; then
  echo "Docker registry version ${DOCKER_REGISTRY_VERSION} is invalid !"
  exit 1
fi
echo "Docker registry version is ${DOCKER_REGISTRY_VERSION}"
# update the auth token
token=$(aws ecr get-login-password)
AUTH_N=$(echo "AWS:${token}" | base64 | tr -d "[:space:]")
export AUTH_N;
# We use a '.new' file to prevent errors like this one.
#     'sed: can't move '/etc/nginx/nginx.confhgFhDa' to '/etc/nginx/nginx.conf': Resource busy'
# To debug this, run `| tee "${nx_conf}` instead of `> "${nx_conf}"`
envsubst "$(env | sed -e 's/=.*//' -e 's/^/\$/g')" < "/etc/nginx/nginx-docker-registry-v${DOCKER_REGISTRY_VERSION}.conf" > "${nx_conf}"