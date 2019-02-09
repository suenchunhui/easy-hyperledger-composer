#!/bin/bash
cd ..

echo "Building BNA ${BNA_FILE_NAME}"

composer archive create --sourceType dir --sourceName /sample-src/composer-bna/ -a /hyperledger/composer/output/${BNA_FILE_NAME}