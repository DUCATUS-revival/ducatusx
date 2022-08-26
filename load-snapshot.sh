#!/bin/bash

source .env

NETWORK=$1
echo $NETWORK

if [ $NETWORK != 'testnet' ] && [ $NETWORK != 'mainnet' ]; 
then
    echo "Network must be testnet or mainnet"
    exit
fi

snapshot_file="ducatusx-$NETWORK-snapshot-latest.tar.gz"
snapshot_url="https://bld.rocknblock.io/ducatus/$snapshot_file"

if [ ! -f "$snapshot_file" ]; then
    wget "$snapshot_url"
fi

mkdir -p snapshot_data
tar xvf "$snapshot_file" -C snapshot_data
docker-compose down
sudo rm -rf "$PARITY_WORKER_PATH/data"
mv snapshot_data/data "$PARITY_WORKER_PATH/data"
sudo chown root:root -R "$PARITY_WORKER_PATH/data"
docker-compose up -d