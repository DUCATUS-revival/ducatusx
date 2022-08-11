# DucatusX Node

## Dependencies

This project leverages Docker in order to keep dependencies manageable and deployment easy.

- docker
- docker-compose

## Deployment

### Standalone node

Create `.env` file and fill it as following example: `env.example`

Parity version will be different for mainnet and testnet configuration and will be set as `PARITY_VERSION`

Persistent node files will be saved to path `PARITY_WORKER_PATH`

### Swarm mode

Note: All  playbooks supports optional arg `service`, in which you can specify hosts. If not specified, tasks will run on all hosts
Example: `make setup_deps service=host1,host2`

1. Fill the `hosts.yml` with any type of credentials you have
2. Run `make create_user` tol create `backend` urer, make paswordless sudo and copy ssh keys to user
3. Change `ansible_user` field in hosts to `backend`
4. Run `make setup_deps` tol install all required dependencies
5. Create new Parity account for nodes (described below) and populate `./ansible/keys/mainnet/name_of_node` directory
6. Run `make setup_global`
7. Go to manager server and copy Swarm Join token:
    * `docker swarm join-token  worker`
8. Go to new node (worker) server and join to Swarm by running command that was outputted on previous part
9. Wait for some time (usually 3-10 minutes), run `docker ps` on new node - it will show one container, and you can check logs on it by `docker logs -f id_of_cointainer`

#### Manager node

Manager node installs similarly, but uses `docker-compose.swarm.yml` compose file.
To update current stack, run:
1. `docker stack deploy -c <(docker-compose -f docker-compose.swarm.yml config) ducatusx`

### Creating new Parity account for nodes

1. Fill `PARITY_WORKER_PATH` in .env with full path of cloned repo on you machine (for example: /home/user/ducatusx)
2. Prepare password for new node - you can use any password generators, create password with 18 characters and without special characters.
    * You can use such command: `< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c\${1:-18};echo;`
3. Run `make create_parity_account.  This command will:
    * Spin up local parity container
    * Request password for new account. Fill generated password here
    * Finally, JSON-file of new account will be saved to `./local_docker_datta/ethereum`
4. Run `make put_keys_mainnet node=name_of_node`.
    This command will create directory `./ansible/keys/mainnet/name_of_node` and copy account file (UTC-*) to it
    `name_of_node` - must be identical to name of host in ansible/hosts.yml 
5. Run `sudo chown -R your_user:your_user ansbile/keys/mainnet/name_of_node` to set correct permissions (Docker will set root permissions on generation, and Ansible can struggle with it)
6. Put password from account to file `./ansbile/keys/mainnet/name_of_node/node.pwd`

