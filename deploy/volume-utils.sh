#!/bin/bash
# Create Confixgen and Cryptogen Volumes
MODE=$1
ID=$2

NETWORK_STARTER_CRYPTO_VOLUME="Crypto"
NETWORK_STARTER_SCRIPTS_VOLUME="Scripts"
NETWORK_STARTER_CHANNEL_VOLUME="Channel"
CA_CRYPTO_VOLUME="CA"

deploy_orderer_volume="deploy_orderer_volume"
deploy_peer_run_volume="deploy_peer_run_volume"

deploy_peer0_crypto_msp="deploy_peer0_crypto_msp_volume"
deploy_peer1_crypto_msp="deploy_peer1_crypto_msp_volume"
deploy_peer2_crypto_msp="deploy_peer2_crypto_msp_volume"
deploy_peer3_crypto_msp="deploy_peer3_crypto_msp_volume"

deploy_peer0_crypto_tls="deploy_peer0_crypto_tls_volume"
deploy_peer1_crypto_tls="deploy_peer1_crypto_tls_volume"
deploy_peer2_crypto_tls="deploy_peer2_crypto_tls_volume"
deploy_peer3_crypto_tls="deploy_peer3_crypto_tls_volume"

NETWORK_STARTER_CRYPTO_PATH="/cryptoPath"
NETWORK_STARTER_SCRIPTS_PATH="/scriptsPath"
NETWORK_STARTER_CHANNEL_PATH="/channelPath"
CA_CRYPTO_PATH="/caPath"

deploy_orderer_path="/deploy_orderer_channel_path"
deploy_peer_run_path="/deploy_peer_run_path"

deploy_peer0_crypto_msp_path="/deploy_peer0_crypto_msp_path"
deploy_peer1_crypto_msp_path="/deploy_peer1_crypto_msp_path"
deploy_peer2_crypto_msp_path="/deploy_peer2_crypto_msp_path"
deploy_peer3_crypto_msp_path="/deploy_peer3_crypto_msp_path"

deploy_peer0_crypto_tls_path="/deploy_peer0_crypto_tls_path"
deploy_peer1_crypto_tls_path="/deploy_peer1_crypto_tls_path"
deploy_peer2_crypto_tls_path="/deploy_peer2_crypto_tls_path"
deploy_peer3_crypto_tls_path="/deploy_peer3_crypto_tls_path"

function createVolume() {
    echo "Copying Files..."

    # Create Container
    dockerContainerId=$(docker run -d \
    -v $NETWORK_STARTER_CRYPTO_VOLUME:$NETWORK_STARTER_CRYPTO_PATH \
    -v $NETWORK_STARTER_SCRIPTS_VOLUME:$NETWORK_STARTER_SCRIPTS_PATH \
    -v $NETWORK_STARTER_CHANNEL_VOLUME:$NETWORK_STARTER_CHANNEL_PATH \
    -v $CA_CRYPTO_VOLUME:$CA_CRYPTO_PATH \
    -v $deploy_orderer_volume:$deploy_orderer_path \
    -v $deploy_peer0_crypto_msp:$deploy_peer0_crypto_msp_path \
    -v $deploy_peer1_crypto_msp:$deploy_peer1_crypto_msp_path \
    -v $deploy_peer2_crypto_msp:$deploy_peer2_crypto_msp_path \
    -v $deploy_peer3_crypto_msp:$deploy_peer3_crypto_msp_path \
    -v $deploy_peer0_crypto_tls:$deploy_peer0_crypto_tls_path \
    -v $deploy_peer1_crypto_tls:$deploy_peer1_crypto_tls_path \
    -v $deploy_peer2_crypto_tls:$deploy_peer2_crypto_tls_path \
    -v $deploy_peer3_crypto_tls:$deploy_peer3_crypto_tls_path \
    ubuntu:16.04)

    # Copy Files Over to Volume
    docker container cp ./crypto-config/. $dockerContainerId:$NETWORK_STARTER_CRYPTO_PATH
    docker container cp ./scripts/. $dockerContainerId:$NETWORK_STARTER_SCRIPTS_PATH
    docker container cp ./channel-artifacts/. $dockerContainerId:$NETWORK_STARTER_CHANNEL_PATH
    docker container cp ./crypto-config/peerOrganizations/org1.example.com/ca/. $dockerContainerId:$CA_CRYPTO_PATH

    docker container cp ./channel-artifacts/genesis.block $dockerContainerId:$deploy_orderer_path/orderer.genesis.block
    docker container cp ./crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/. $dockerContainerId:$deploy_orderer_path

    docker container cp ./crypto-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/msp/. $dockerContainerId:$deploy_peer0_crypto_msp_path
    docker container cp ./crypto-config/peerOrganizations/org1.example.com/peers/peer1.org1.example.com/msp/. $dockerContainerId:$deploy_peer1_crypto_msp_path
    docker container cp ./crypto-config/peerOrganizations/org1.example.com/peers/peer2.org1.example.com/msp/. $dockerContainerId:$deploy_peer2_crypto_msp_path
    docker container cp ./crypto-config/peerOrganizations/org1.example.com/peers/peer3.org1.example.com/msp/. $dockerContainerId:$deploy_peer3_crypto_msp_path

    docker container cp ./crypto-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/. $dockerContainerId:$deploy_peer0_crypto_tls_path
    docker container cp ./crypto-config/peerOrganizations/org1.example.com/peers/peer1.org1.example.com/tls/. $dockerContainerId:$deploy_peer1_crypto_tls_path
    docker container cp ./crypto-config/peerOrganizations/org1.example.com/peers/peer2.org1.example.com/tls/. $dockerContainerId:$deploy_peer2_crypto_tls_path
    docker container cp ./crypto-config/peerOrganizations/org1.example.com/peers/peer3.org1.example.com/tls/. $dockerContainerId:$deploy_peer3_crypto_tls_path

    echo "Copy Files Complete..."

    # Delete Container
    docker rm $dockerContainerId
    echo "Delete Temp Container Complete..."

    # Create Docker Container for Persistence if not exists
    docker volume create deploy_peer0_couchdb
    docker volume create deploy_peer1_couchdb
    docker volume create deploy_peer2_couchdb
    docker volume create deploy_peer3_couchdb
    docker volume create deploy_orderer_production_volume
}

function deleteVolume() {
    docker volume rm -f \
    $NETWORK_STARTER_CRYPTO_VOLUME \
    $NETWORK_STARTER_SCRIPTS_VOLUME \
    $NETWORK_STARTER_CHANNEL_VOLUME \
    $CA_CRYPTO_VOLUME \
    $deploy_orderer_volume \
    $deploy_peer0_crypto_msp \
    $deploy_peer1_crypto_msp \
    $deploy_peer2_crypto_msp \
    $deploy_peer3_crypto_msp \
    $deploy_peer0_crypto_tls \
    $deploy_peer1_crypto_tls \
    $deploy_peer2_crypto_tls \
    $deploy_peer3_crypto_tls
}

if [ "$MODE" == "DELETE" ]
then 
    echo 'Deleting Volumes...'
    deleteVolume
elif [ "$MODE" == "CREATE" ]
then 
    echo 'Creating Volumes...'
    deleteVolume
    createVolume
fi