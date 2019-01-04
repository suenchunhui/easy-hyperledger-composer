bash ./deploy.sh up

CHANNEL_NAME="composerchannel"
DELAY=3
bash ./scripts/create_channel.sh $CHANNEL_NAME $DELAY

# Create Peer Admin Card
bash ./scripts/createPeerAdminCard_localmap.sh