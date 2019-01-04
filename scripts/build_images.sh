CURR_DIR=$PWD

cd "$CURR_DIR"

# Build Network Starter Image
ln -fs "$CURR_DIR/deploy/network-starter/.dockerignore" .dockerignore
docker build -t network-starter -f ./deploy/network-starter/Dockerfile "$CURR_DIR"
unlink "$CURR_DIR/.dockerignore"

# Build Fabric related images
docker pull hyperledger/fabric-orderer:x86_64-1.1.0
docker pull hyperledger/fabric-peer:x86_64-1.1.0
docker pull hyperledger/fabric-tools:x86_64-1.1.0
docker pull hyperledger/fabric-ca:x86_64-1.1.0
docker pull hyperledger/fabric-couchdb:0.4.10

# Fabric REST server image
cd "$CURR_DIR/fabric-rest-server"
bash ./build_images.sh

cd "$CURR_DIR"