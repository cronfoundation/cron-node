
## NEO Masternode Docker

This docker is used for private NEO blockchain masternodes

### Information

~~~

Folder structure inside docker:
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

~~~

### Cat Makefile for command shortcuts

~~~
cat Makefile
~~~


### Edit config files

Config files will be copied to docker image in build stage

Edit config/config.json
Edit config/protocol.json

### Add new wallet for each masternode 

Edit config/wallet.json

### Add env variables to server

Use private wallet that are not committed into git

~~~
NEOWALLET=wallet.json
NEOPASSWORD=1234567890
~~~

### Add wallet file for this 



### Build docker image



### Start masternode

