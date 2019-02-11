#!/bin/bash

MODE=$1
COMPOSER_CARD=$2
REST_PORT=$3

if [ "$MODE" == up ]; then
    echo "Starting REST SERVER for ${COMPOSER_CARD} at Port ${REST_PORT}"

    docker run \
        -d \
        -e COMPOSER_CARD=$COMPOSER_CARD \
        -e REST_PORT=$REST_PORT \
        -e HOME=/home/composer \
        -v composer_cred:/home/composer/ \
        --network fabric_net \
        --name fabric_rest_$REST_PORT \
        -p $REST_PORT:$REST_PORT \
        composer_rest_server

    docker network connect deploy_ca_net

elif [ "$MODE" == down ]; then
    echo "Stopping REST SERVER for ${COMPOSER_CARD} at Port ${REST_PORT}"
    docker rm -f fabric_rest_$REST_PORT || /bin/true || /usr/bin/true

else
    echo "Invalid Mode. Only up or down accepted"
fi