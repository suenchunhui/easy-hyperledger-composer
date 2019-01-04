#!/bin/bash

MODE=$1
NETWORK_NAME="fabric_net"

function createNetwork() {
    if(docker network create $1)
    then
        echo "Network $1 Created..."
    else
        echo "Network $1 already existed, not creating..."
    fi
}

function deleteNetwork() {
    if(docker network rm $1)
    then
        echo "Network $1 deleted..."
    else
        echo "Network $1 not found or not deleted..."
    fi
}

if [ "$MODE" == "START" ]
then
    createNetwork $NETWORK_NAME
elif [ "$MODE" == "STOP" ]
then
    deleteNetwork $NETWORK_NAME
fi