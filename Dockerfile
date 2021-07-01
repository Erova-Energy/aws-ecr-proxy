FROM nginx:1.21.0
# install glibc compatibility for alpine
RUN apt-get update && apt-get install -y zip wget \
    && curl -sL https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -o awscliv2.zip \
    && unzip awscliv2.zip \
    && aws/install \
    && rm -rf \
        awscliv2.zip \
        aws \
        /usr/local/aws-cli/v2/*/dist/aws_completer \
        /usr/local/aws-cli/v2/*/dist/awscli/data/ac.index \
        /usr/local/aws-cli/v2/*/dist/awscli/examples
ENV AUTH_INDEX=0
ENV DOCKER_REGISTRY_VERSION=2
ENV RENEW_TOKEN=4h
ADD configs/nginx/ssl /etc/nginx/ssl
ADD configs/nginx/*.conf /etc/nginx/
ADD configs/*.sh /

EXPOSE 80 443
HEALTHCHECK --interval=1m --timeout=3s \
  CMD curl -f http://localhost/ping || exit 1
ENTRYPOINT ["/entrypoint.sh"]

CMD ["nginx", "-g", "daemon off;"]
