FROM hyperledger/fabric-tools:x86_64-1.1.0

# Install fuser
RUN apt-get update && apt-get install -y psmisc

# Install Docker
COPY ./scripts/utils/install_docker.sh /install_docker.sh
RUN sudo chmod a+x /install_docker.sh && ./install_docker.sh

# Copy over package.json
RUN mkdir -p /sample-src/deploy
WORKDIR /sample-src/deploy

# Install Composer CLI & Mocha
RUN npm install --unsafe-perm -g composer-client@0.19.12 composer-cli@0.19.12 composer-admin@0.19.12 mocha@3.2.0 chai@3.5.0

# Prevent uneeded reinstall of npm libraries if package.json wasnt changed
COPY ./deploy/network-starter/package.json /sample-src/
RUN npm install

# Port over project files
# COPY ./ /sample-src/
COPY ./deploy/ /sample-src/deploy
COPY ./scripts/ /sample-src/scripts

# Allow Scripts to run
RUN sudo chmod a+x -R ./scripts ./deploy.sh ./network-starter/network_starter_scripts

ENTRYPOINT ["bash", "./network-starter/network_starter_scripts/interface.sh"]
CMD []