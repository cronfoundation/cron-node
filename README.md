# CRON Docker

This docker is used for CRON blockchain

# Installation

## Hardware requirements

|  | Minimum | Recommended |
| --- | --- | --- |
| System | Windows 10<br/>Ubuntu 16.04/18.04<br/>CentOS 7.4/7.6 | Windows 10<br/>Ubuntu 16.04/18.04<br/>CentOS 7.4/7.6 |
| CPU | Dual core | Quad core |
| Memory | 8G | 16G |
| Hard Disk | 50G SSD hard drive | 100G SSD hard drive |


## Install docker
~~~bash
sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

sudo apt-get update && sudo apt-get install -y docker-ce
~~~

#### Install docker-compose
~~~bash
sudo curl -L https://github.com/docker/compose/releases/download/1.18.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
docker-compose --version
~~~

## Setup seed(cron-node) using docker

### Clone repository
~~~sh
# clone repository
git clone https://github.com/cronfoundation/cron-node.git
cd cron-node
~~~

### Install make
~~~sh
# install make
sudo apt-get install make -y
~~~

### Docker setup
~~~sh
# add docker network
sudo docker network create neo

# build docker image
sudo make build

# start seed node
sudo make run

# see running containers
sudo docker ps -a
sudo docker ps -a | grep cron

# access cron-cli
sudo make cli

# access bash inside docker 
sudo make exec

# curl request to api to see sync status, from inside docker, or from outside if ports are opened.
curl -d '{"jsonrpc": "2.0", "method": "getblockcount", "params": [], "id": 5}' localhost:10332

~~~

## Open firewall ports
~~~sh
# 10333 - P2P communication, required for node synchronization
# 10332 - RPC-API access (WARNING! by opening this port if you have unlocked wallet everyone can access private key)
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow ssh
sudo ufw allow 10333
sudo ufw allow 10332 #(WARNING! by opening this port if you have unlocked wallet everyone can access private key)
sudo ufw enable
~~~

# Information 
##  Folder structure inside docker
~~~
/neo-cli/Index_00A80801
/neo-cli/Chain_00A80801

Ports:
10331 - JSON-RPC via HTTPS
10332 - JSON-RPC via HTTP 
10333 - P2P via TCP
10334 - P2P via WebSocket

config.json
"Magic": 67827978 - for each blockchain this should be different, (67827978 = CRON in decimal) from this is created folder structure name "00A80801"
StandbyValidators - Masternode public keys
SeedList - Masternode and RPC node list

#(WARNING! by opening JSON-RPC port 10332 or 10331, if you have unlocked wallet everyone can access private key)
~~~

## Cat Makefile for command shortcuts

~~~
cat Makefile
~~~


## Edit config files

Config files will be copied to docker image in build stage

Edit config/config.json
Edit config/protocol.json

## Auth for RPC
To add RPC authentication capabilities, copy the contents of the file  `config/rpc_security_conf.json` here
 `/Plugins/RpcSecurity/config.json`. 
  In this case, the request to the node will change to this
 `curl -d '{"jsonrpc": "2.0", "method": "getblockcount", "params": [], "id": 5}' admin:123@127.0.0.1:10332`