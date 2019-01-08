DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Remove all docker containers
bash "$DIR/stop_fabric.sh"
docker ps -a | grep composer_rest_server | awk -F ' ' '{print $1}' | xargs docker rm -f
docker ps -a | grep composer-playground | awk -F ' ' '{print $1}' | xargs docker rm -f

# Clear all docker volumes
bash "$DIR/clean_crypto.sh"
docker volume rm \
    composer_bna \
    composer_cred \
    deploy_peer0_couchdb \
    deploy_peer1_couchdb \
    deploy_peer2_couchdb \
    deploy_peer3_couchdb \
    deploy_orderer_production_volume

# Clear all docker networks
docker network rm \
    deploy_ca_net \
    deploy_cc0_net \
    deploy_cc1_net \
    deploy_cc2_net \
    deploy_cc3_net \
    fabric_net