# DucatusX Node

## Dependencies

This project leverages Docker in order to keep dependencies manageable and deployment easy.

- docker
- docker-compose

## Chain configuration

Chain specification file and global node configs located in:
- configs/mainnet - configurations for DucatusX Mainnet
- configs/testnet - configurations for DucatusX Testnet

## Deployment

1. Clone this repository

2. Create `.env` file and fill it as following example: `env.example`
- OpenEthereum version must be set as `PARITY_VERSION` in `.env`
- OpenEthereum version can be set to any stable version, at this moment v3.3.1 provides optimal experience. 
- Persistent node files will be saved to path `PARITY_WORKER_PATH`. 
- Configuration files will be taken from `PARITY_WORKER_PATH` folder.

3. Run `source .env`
4. Copy configuration files:
- Mainnet: `cp configs/mainnet/* $PARITY_WORKER_PATH/`
- Testnet: `cp configs/testnet/* $PARITY_WORKER_PATH/`

5. If neccessary, make additional changes to OpenEthereum configuration (will be located in `<PARITY_WORKER_PATH>/config.toml`)
6. Start node: `docker compose up -d`
7. View node logs: `docker compose logs`
