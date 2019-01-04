docker run \
--rm \
--name networkStarter \
-v "$PWD/composer-bna/:/sample-src/composer-bna/" \
-v "$PWD/test/:/sample-src/test/" \
network-starter test_bna