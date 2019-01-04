# CLI approach - Comment this line if you are using the RESTful POST method to add participants
composer participant add -c admin@${FABRIC_NETWORK_NAME} -d \
    '{"$class":"org.hyperledger_composer.marbles.Player","email":"mae@biznet.org","firstName":"Mae","lastName":"Smith"}'

# Issue Card for the identity
composer identity issue -c admin@${FABRIC_NETWORK_NAME} -f ${UNIQUE_IDENTIFIER}.card -u ${UNIQUE_IDENTIFIER} -a "org.hyperledger_composer.marbles.Player#${PARTICIPANT_ID}"

# Import Card into Wallet
composer card import -f ${UNIQUE_IDENTIFIER}.card

# Activate Card
composer network ping -c ${UNIQUE_IDENTIFIER}@${FABRIC_NETWORK_NAME}