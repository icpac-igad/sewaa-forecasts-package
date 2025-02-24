ARG NODE_VERSION=20
FROM node:${NODE_VERSION}-alpine AS builder

ARG VITE_API_URL="http://127.0.0.1/api"
ARG WEB_REPO=https://github.com/icpac-igad/prime-cgan.git

RUN apk update --no-cache && apk add git && \
    git clone --depth 1 ${WEB_REPO} /tmp/web

ENV VITE_API_URL=${VITE_API_URL}
WORKDIR /tmp/web

RUN yarn install && yarn run build

FROM alpine AS source

ARG DHPARAM_DIR=/var/srv/dhparam.cert
ARG ERROR_PAGES_REPO=https://github.com/jaysnm/nginx-errors.git

RUN apk update && \
    apk add --update --no-cache -f curl git openssl libressl && \
    git clone --depth 1 ${ERROR_PAGES_REPO} /opt/share && \
    mkdir -p ${DHPARAM_DIR} && \
    openssl dhparam -dsaparam -out ${DHPARAM_DIR}/dhparams.pem 4096

FROM nginx:alpine AS runner

ARG ERROR_PAGES=/usr/share/nginx/error-pages
ARG APP_DIR=/opt/app
ARG APP_HOME=/opt/www
ARG DHPARAM_DIR=/var/srv/dhparam.cert

RUN mkdir -p ${APP_HOME} ${ERROR_PAGES} ${DHPARAM_DIR}
WORKDIR ${APP_HOME}

COPY --from=builder /tmp/web/dist ${APP_HOME}
COPY --from=source /opt/share ${ERROR_PAGES}
COPY --from=source ${DHPARAM_DIR}/dhparams.pem ${DHPARAM_DIR}/dhparams.pem
COPY ./nginx/security.conf ./nginx/ssl-options.conf /etc/nginx/
COPY ./nginx/default.conf /etc/nginx/conf.d/default.conf 
COPY ./nginx/dev-site.conf /etc/nginx/conf.d/site.conf
