./deploy.sh down && ./start_network.sh STOP
#destroy ledger state store
docker volume rm -f deploy_peer0_couchdb deploy_peer1_couchdb deploy_peer2_couchdb deploy_peer3_couchdb

# Clear all chaincode images
./deploy.sh clean