#!/bin/bash

# Exit on first error
set -e
# Grab the current directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
if [ -f /usr/local/bin/composer ]; then
    COMPOSER_CLI=/usr/local/bin/composer
else
    COMPOSER_CLI=$DIR/../../node_modules/composer-cli/cli.js
fi

#set location of composer-wallet if not defined
HOME=${HOME:-$DIR/..}

#remove previous credentials
rm -rf $HOME/.composer/*

echo
# check that the composer command exists at a version >v0.14
if hash $COMPOSER_CLI 2>/dev/null; then
    $COMPOSER_CLI --version | awk -F. '{if ($2<15) exit 1}'
    if [ $? -eq 1 ]; then
        echo 'Sorry, Use createConnectionProfile for versions before v0.15.0'
        exit 1
    else
        echo Using composer-cli at `$COMPOSER_CLI --version`
    fi
else
    echo 'Need to have composer-cli installed at v0.15 or greater'
    exit 1
fi
# need to get the certificate

CERT_DIR="/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto"

ORDERER_TLS_CERT=`cat $CERT_DIR/ordererOrganizations/example.com/orderers/orderer.example.com/tls/server.crt | sed 's/$/\\\\n/' | tr -d '\n'`
PEER0_TLS_CERT=`cat $CERT_DIR/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/server.crt | sed 's/$/\\\\n/' | tr -d '\n'`
PEER1_TLS_CERT=`cat $CERT_DIR/peerOrganizations/org1.example.com/peers/peer1.org1.example.com/tls/server.crt | sed 's/$/\\\\n/' | tr -d '\n'`
PEER2_TLS_CERT=`cat $CERT_DIR/peerOrganizations/org1.example.com/peers/peer2.org1.example.com/tls/server.crt | sed 's/$/\\\\n/' | tr -d '\n'`
PEER3_TLS_CERT=`cat $CERT_DIR/peerOrganizations/org1.example.com/peers/peer3.org1.example.com/tls/server.crt | sed 's/$/\\\\n/' | tr -d '\n'`


# Check for Docker
ordererAddr="orderer.example.com";
caAddr="ca.org1.example.com";
peer0Addr="peer0.org1.example.com";
peer1Addr="peer1.org1.example.com";
peer2Addr="peer2.org1.example.com";
peer3Addr="peer3.org1.example.com";

cat << EOF > .connection.json
    {
    "name": "hlfv1",
    "x-type": "hlfv1",
    "version": "1.0.0",
    "client": {
        "organization": "Org1",
        "connection": {
            "timeout": {
                "peer": {
                    "endorser": "300",
                    "eventHub": "300",
                    "eventReg": "300"
                },
                "orderer": "300"
            }
        }
    },
    "organizations": {
        "Org1": {
            "mspid": "Org1MSP",
            "peers": [
                "peer0.org1.example.com",
                "peer1.org1.example.com",
                "peer2.org1.example.com",
                "peer3.org1.example.com"
            ],
            "certificateAuthorities": [
                "ca.org1.example.com"
            ]
        }
    },
    "orderers": {
       "orderer.example.com": {
            "url": "grpc://${ordererAddr}:7050"
        }
    }
    ,
    "certificateAuthorities": {
        "ca.org1.example.com": {
            "url": "http://${caAddr}:7054",
            "name": "ca.org1.example.com"
        }
    },
    "peers": {
        "peer0.org1.example.com": {
            "url": "grpc://${peer0Addr}:7051",
            "eventUrl": "grpc://${peer0Addr}:7053"
        },
        "peer1.org1.example.com": {
             "url": "grpc://${peer1Addr}:7051",
            "eventUrl": "grpc://${peer1Addr}:7053"
        },
        "peer2.org1.example.com": {
            "url": "grpc://${peer2Addr}:7051",
            "eventUrl": "grpc://${peer2Addr}:7053"
        },
        "peer3.org1.example.com": {
           "url": "grpc://${peer3Addr}:7051",
            "eventUrl": "grpc://${peer3Addr}:7053"
        }
    },
    "keyValStore": "/var/cred/.composer-credentials",
    "channels": {
        "composerchannel": {
            "orderers": [
                "orderer.example.com"
            ],
            "peers": {
                "peer0.org1.example.com": {
                     "endorsingPeer": true,
                     "chaincodeQuery": true,
                     "eventSource": true
                },
                "peer1.org1.example.com": {
                     "endorsingPeer": true,
                     "chaincodeQuery": true,
                     "eventSource": true
                },
                "peer2.org1.example.com": {
                     "endorsingPeer": true,
                     "chaincodeQuery": true,
                     "eventSource": true
                },
                "peer3.org1.example.com": {
                     "endorsingPeer": true,
                     "chaincodeQuery": true,
                     "eventSource": true
                }
            }
        }
    }
}
EOF


SK_FILE=`ls $CERT_DIR/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp/keystore/ | grep _sk`
PRIVATE_KEY=$CERT_DIR/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp/keystore/$SK_FILE
CERT=$CERT_DIR/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp/signcerts/Admin@org1.example.com-cert.pem

if $COMPOSER_CLI card list -c PeerAdmin@hlfv1 > /dev/null; then
    $COMPOSER_CLI card delete -c PeerAdmin@hlfv1
fi
$COMPOSER_CLI card create -p .connection.json -u PeerAdmin -c "${CERT}" -k "${PRIVATE_KEY}" -r PeerAdmin -r ChannelAdmin --file .PeerAdmin@hlfv1.card
$COMPOSER_CLI card import --file .PeerAdmin@hlfv1.card

rm -f .connection.json .PeerAdmin@hlfv1.card

echo "Hyperledger Composer PeerAdmin card has been imported"
$COMPOSER_CLI card list


