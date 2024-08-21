#!/bin/zsh

if [ "$1" = "" ]; then
    echo "missing network"
    exit 1
fi

DIRNAME=`dirname $0`
NETWORK=$1

./scripts/deploy.sh $NETWORK third-eye approve
./scripts/deploy.sh $NETWORK charts_server approve
./scripts/deploy.sh $NETWORK gearbox-ws approve

if [ "$NETWORK" = "anvil" ] || [ "$NETWORK" = "arbtest" ] || [ "$NETWORK" = "opttest" ]; then
    ./scripts/deploy.sh $NETWORK webhook approve
fi

if [ "$NETWORK" = "anvil" ]; then
    ./scripts/deploy.sh $NETWORK gpointbot approve
    ./scripts/deploy.sh $NETWORK trading_price approve
fi

# curl -XPOST --insecure https://arbtest.gearbox.foundation/webhook/anvil_fork_reset
# curl -XPOST --insecure https://testnet.gearbox.foundation/webhook/anvil_fork_reset
