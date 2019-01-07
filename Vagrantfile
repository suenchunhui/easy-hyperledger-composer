# -*- mode: ruby -*-
# vi: set ft=ruby :
# Vagrant provisioning script for creating a standalone hyperledger fabric and composer environment
# Copyright (C) 2017 Suen Chun Hui

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

VAGRANTFILE_API_VERSION = "2"

$script = <<SCRIPT
set -x

#make sure apt retries if download fails
echo "APT::Acquire::Retries \"3\";" > /etc/apt/apt.conf.d/80-retries

#install docker
apt-get update
apt-get install apt-transport-https ca-certificates curl software-properties-common build-essential
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
apt-key fingerprint 0EBFCD88
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu `lsb_release -cs` stable"
apt-get update
apt-get install -y docker-ce
addgroup vagrant docker
echo '#!/bin/bash' > /etc/rc.local
echo 'service docker start' >> /etc/rc.local
echo 'sleep 10'
echo "docker ps -a | grep "fabric-couchdb" | awk '{print \$1}' | xargs docker restart " >> /etc/rc.local
service docker start

#install docker-compose
curl -L "https://github.com/docker/compose/releases/download/1.23.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod a+x /usr/local/bin/docker-compose

#install nodejs, n, npm
apt-get install -y npm
npm install -g npm
npm install -g n
n 9
rm -rf /usr/bin/node /usr/bin/nodejs
cd /usr/local/bin/ ; ln -s node nodejs

#install yeoman tools, angular http-server, composer-generator
npm install --unsafe-perm -g yo generator-fountain-webapp http-server@0.10.0 typings bower @angular/cli generator-hyperledger-composer

#install cloud9 IDE
cd /home/vagrant
mkdir /home/vagrant/workspace
su vagrant -c "git clone https://github.com/c9/core.git cloud9 ; cd cloud9 ; NO_PULL=1 scripts/install-sdk.sh ; chmod a+rw -R build"
echo 'cd /home/vagrant/cloud9 ; su vagrant -c "screen -d -m nodejs server.js -l 0.0.0.0 -w /home/vagrant/workspace --auth root:secret"' >> /etc/rc.local
su vagrant -c "cd cloud9 ; screen -d -m nodejs server.js -l 0.0.0.0 -w /home/vagrant/workspace --auth root:secret"

echo "exit 0" >> /etc/rc.local

#call build_image
cp -rf /vagrant/* /home/vagrant/workspace
sudo chown vagrant -R /home/vagrant/workspace
su vagrant -c "cd /home/vagrant/workspace ; npm run build_image"

SCRIPT


Vagrant.configure('2') do |config|
  config.vm.box = "ubuntu/xenial64"
  config.vm.provider "virtualbox" do |v|
    v.memory = 4096
    v.cpus = 4
  end

  config.vm.provision "shell", inline: $script
  config.vm.network :forwarded_port, guest: 8080, host: 8080  #composer
  config.vm.network :forwarded_port, guest: 8181, host: 8181  #cloud9-ide
  config.vm.network :forwarded_port, guest: 9090, host: 9090  #custom-ui

  config.vm.network :forwarded_port, guest: 3000, host: 3000  #rest-server
  config.vm.network :forwarded_port, guest: 3001, host: 3001  #
  config.vm.network :forwarded_port, guest: 3002, host: 3002  #
  config.vm.network :forwarded_port, guest: 3003, host: 3003  #
end
