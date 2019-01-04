#!/bin/bash

composer network install -a $1 -c PeerAdmin@hlfv1 
composer network upgrade -c PeerAdmin@hlfv1 -n marbles-network -V $BNA_VERSION