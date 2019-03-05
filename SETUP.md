## Setup steps in node
~~~bash
# SSH into server
ssh -i /Users/eduards/Sites/Keys/eduards_dev.pem ubuntu@masternode1
~~~

#### Setup docker

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

#### Setup docker-compose
~~~bash
sudo curl -L https://github.com/docker/compose/releases/download/1.18.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
docker-compose --version
~~~

#### Setup node
~~~bash
# clone git repo, use your own username and password
git clone https://eduardsm@bitbucket.org/andit-team/neo-masternode-docker.git
cd neo-masternode-docker

# install make
sudo apt-get install make -y

# change protocol.json, add 4 server ip addresses in SeedList block, it should be the same for all 4 servers
sudo nano config/protocol.json

# Change wallet information and change env file password
# Every masternode need different wallet 
# For test network we can use these wallets included in config/wallets.txt (Copy wallet 2, 3, 4 into wallet json file, different for each server)
# Wallet public keys are listed in config/protocol.json StandbyValidators

# on server 1, do nothing with wallets

# on server 2
sudo rm config/wallet.json
sudo mv config/wallet2.json config/wallet.json

# on server 3
sudo rm config/wallet.json
sudo mv config/wallet3.json config/wallet.json

# on server 4
sudo rm config/wallet.json
sudo mv config/wallet4.json config/wallet.json

# docker build
sudo make build

# add docker network
sudo docker network create neo

# Start masternode
sudo make run

# Access cli, 
# if you see black screen try to type "help" twice, or move terminal/ resize screen size
# just remember not to quit it with ctrl+d, always use CTRL+A CTRL+D combo. 
sudo make cli

#when you are in neo cli 
neo> 

# install plugins and then restart node cli, (quit CTRL+D, sudo make down, sudo make run)
neo> install SimplePolicy
neo> install ApplicationLogs

# make sure plugins are installed
neo> plugins

#openwallet
neo> open wallet wallet.json
password: **********
neo> 

# Exit cli 
# to detach from screen and keep it running (CTRL+A then +D, KEPP HOLDING CTRL) !!!

# When all 4 instances has been started, and every node sees each other, using cli function "show state"
neo> show state

# start consensus, and do not close this terminal, keep it running (CTRL+A then +D, KEPP HOLDING CTRL) !!!
neo> start consensus

~~~

#### access json-rpc api
~~~bash
# curl command "getblockcount"
curl -d '{"jsonrpc": "2.0", "method": "getblockcount", "params": [], "id": 5}'  http://localhost:10332

# returns block height
{"jsonrpc":"2.0","id":5,"result":17}
~~~