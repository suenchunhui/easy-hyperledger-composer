#!/bin/bash

npm run build_image

npm run test_bna

npm run setup_crypto

npm run start_fabric

npm run build_bna marbles.bna

npm run install_bna marbles-network marbles.bna

# npm run upgrade_bna

npm run start_playground

npm run stop_playground

# # # Start Rest Server with Admin Card on port 3000
# # # SYNTAX: npm run rest-server <admin card> <port>
npm run start_rest-server admin@marbles-network 3000

# # # Add Participant Card with maeid1
# # # SYNTAX: npm run add_participant <UNIQUE_IDENTIFIER> <PARTICIPANT_ID> <NETWORK_NAME>
npm run add_participant maeid1 mae@biznet.org marbles-network

# # # Start Rest Server with maeid1 Card on port 3001
# # # SYNTAX: Card Name is <UNIQUE_IDENTIFIER>@<Business Network Name>
npm run start_rest-server maeid1@marbles-network 3001

# npm run stop_rest-server admin@marbles-network 3000

# npm run stop_rest-server maeid1@marbles-network 3001

# Reset all Fabric Transactions
npm run reset_fabric admin@marbles-network

npm run stop_fabric

npm run clean_network