#!/usr/bin/env bash
COMMAND=$1
HOME=/opt/cred

SCRIPT_LOCATION="./network-starter"

if [ $COMMAND = "setup" ]
then
    echo "Setting up"
    bash ./deploy.sh "generate"
    bash ./volume-utils.sh "CREATE"
elif [ $COMMAND = "start" ]
then
    echo "Starting Fabric"
    # Create Docker Channel
    docker network create "fabric_net"
    docker network connect fabric_net networkStarter

    $SCRIPT_LOCATION/network_starter_scripts/start_fabric.sh
elif [ $COMMAND = "build_bna" ]
then
    echo "Creating BNA"

    $SCRIPT_LOCATION/network_starter_scripts/create_bna.sh
elif [ $COMMAND = "install_bna" ]
then
    echo "Installing BNA"
    docker network connect fabric_net networkStarter
    docker network connect deploy_ca_net networkStarter

    $SCRIPT_LOCATION/network_starter_scripts/install_bna.sh
elif [ $COMMAND = "upgrade_bna" ]
then
    echo "Upgrading BNA"
    docker network connect fabric_net networkStarter
    docker network connect deploy_ca_net networkStarter

    $SCRIPT_LOCATION/network_starter_scripts/upgrade_bna.sh
elif [ $COMMAND = "add_participant" ]
then
    echo "Add Participant"
    docker network connect fabric_net networkStarter
    docker network connect deploy_ca_net networkStarter

    $SCRIPT_LOCATION/network_starter_scripts/add_participant.sh
elif [ $COMMAND = "test_bna" ]
then
    echo "Running Tests"

    $SCRIPT_LOCATION/network_starter_scripts/test_bna.sh
elif [ $COMMAND = "stop_fabric" ]
then
    echo "Stopping Fabric"

    $SCRIPT_LOCATION/network_starter_scripts/stop_fabric.sh
    docker ps -a | grep composer_rest_server | xargs docker rm -f || /bin/true
    docker ps -a | grep composer-playground | xargs docker rm -f || /bin/true
elif [ $COMMAND = "clean" ]
then
    echo "clean up crypto volume"
    bash ./volume-utils.sh "DELETE"
elif [ $COMMAND = "reset_fabric" ]
then
    echo "Reset Fabric"
    docker network connect fabric_net networkStarter
    docker network connect deploy_ca_net networkStarter
    
    $SCRIPT_LOCATION/network_starter_scripts/reset_fabric.sh
else
    echo "Invalid Command"
fi