# chain-configuration

## 1. Building

## 1.1 Build Dependencies

- curl https://sh.rustup.rs -sSf | sh

- sudo apt update

- sudo apt install -y build-essential g++ pkg-config file make cmake perl yasm git cargo libudev-dev

## 1.2 Build from Source Code

- git clone https://github.com/DUCATUS-revival/parity-ethereum

- cd parity-ethereum

- git checkout stable

- cargo build --release --features final

## 2 Configurate Parity DucatusX

## 2.1 Copy release to bin folder, write

- sudo install ./target/release/parity /usr/bin/parity

## 2.2 Download DucatusX config

- git clone https://github.com/DUCATUS-revival/chain-configuration

## 2.3 Configure client Parity DucatusX

- cd chain-configuration

- !!!For mainnet configuration: (git checkout mainnet)

- sed -i 's,$HOME,'$HOME',g' config.toml

- sudo mkdir /etc/ducatusx

- sudo cp config.toml /etc/ducatusx/config.toml

## 2.4 Set systemd service DucatusX

- sudo cp ducatusx.service /etc/systemd/system/ducatusx.service

## 2.5 Configure chain DucatusX

- mkdir $HOME/.ducatusx

- sudo cp chain.json $HOME/.ducatusx/chain.json

## 3. Run Parity DucatusX

- sudo systemctl start ducatusx

## 4. See status:

- sudo systemctl status ducatusx

