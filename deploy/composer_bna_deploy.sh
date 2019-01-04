# composer network install -a $1 -c PeerAdmin@hlfv1 
# VERSION=$(composer archive list -a $1 | sed -ne 's/^Version://p')
# composer network start rt -n marbles-network -V $VERSION -A admin -S adminpw -c PeerAdmin@hlfv1
# composer card import -f admin@marbles-network.card
# composer network ping -c admin@marbles-network
# rm admin@marbles-network.card

composer network install -a $1 -c PeerAdmin@hlfv1 
VERSION=$(composer archive list -a $1 | sed -ne 's/^Version://p')
composer network start rt -n $FABRIC_NETWORK_NAME -V $VERSION -A admin -S adminpw -c PeerAdmin@hlfv1
composer card import -f admin@$FABRIC_NETWORK_NAME.card
composer network ping -c admin@$FABRIC_NETWORK_NAME
rm admin@$FABRIC_NETWORK_NAME.card