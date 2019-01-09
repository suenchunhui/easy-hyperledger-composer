#!/bin/bash

MODE=$1

if [ "$MODE" == up ]; then
    echo "Starting Composer Playground on port 8080"

    docker run \
    --rm \
    -d \
    -v composer_cred:/var/cred \
    -p 8080:8080 \
    --network fabric_net \
    --env HOME=/var/cred \
    -u root \
    --name composer-playground \
    hyperledger/composer-playground:0.19.12

    docker network connect deploy_ca_net composer-playground

elif [ "$MODE" == down ]; then
    echo "Stopping Composer Playground on port 8080"
    docker rm -f composer-playground || /bin/true

else
    echo "Invalid Mode. Only up or down accepted"
fi