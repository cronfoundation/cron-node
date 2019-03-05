#!/bin/bash
#
# This script starts four consensus and waits forever
#


echo ${NEOWALLET}
echo ${NEOPASSWORD}

# screen -dmS node expect /neo-cli/start_consensus_node.sh ${NEOWALLET} ${NEOPASSWORD}
#screen -dmS node /neo-cli/start_consensus_node.sh ${NEOWALLET} ${NEOPASSWORD}
screen -dmS node dotnet neo-cli.dll --rpc

sleep 12000000
