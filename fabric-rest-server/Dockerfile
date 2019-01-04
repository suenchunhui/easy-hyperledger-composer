FROM node:carbon-jessie

RUN npm install --unsafe-perm -g composer-rest-server@0.19.12

COPY ./entrypoint.sh /entrypoint.sh

ENTRYPOINT [ "bash", "/entrypoint.sh" ]