Mainnet node can stop syncing at block #110

Current fix for this issue is to launch node from blochain snapshot.

Link for snapshot archive: 
* Mainnet: https://bld.rocknblock.io/ducatus/ducatusx-mainnet-snapshot-latest.tar.gz
* Testnet: https://bld.rocknblock.io/ducatus/ducatusx-testnet-snapshot-latest.tar.gz

Steps to run node from snapshot:

0. Go to cloned repo directory (for example, `/var/www/ducatus`)
1. Activate repo environment: `source .env`
2. Download snapshot: `wget https://bld.rocknblock.io/ducatus/ducatusx-mainnet-snapshot-latest.tar.gz`
3. Create folder to uncompress snapshot: `mkdir -p snapshot_data`
4. Uncompress snapshot data: `tar xvf ducatusx-mainnet-snapshot-latest.tar.gz -C snapshot_data`
5. Stop DucatusX node container: `docker compose down`
6. Delete original data: `sudo rm -rf $PARITY_WORKER_PATH/data`
7. Move snapshot data to node worker path: `mv snapshot_data/data $PARITY_WORKER_PATH/data`
8. Apply root permissions: `sudo chown root:root -R $PARITY_WORKER_PATH/data`
9. Launch DucatusX node again: `docker compose up -d`
10. View logs: `docker compose logs -f`


Also available as script: `./load-snapshot.sh <mainnet/testnet>`
