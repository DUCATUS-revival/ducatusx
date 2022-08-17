Described steps requires Ansible and currently can be used only to setup mining nodes

### Automated node preparation

Note: All  playbooks supports optional arg `service`, in which you can specify hosts. If not specified, tasks will run on all hosts
Example: `make setup_deps service=host1,host2`

1. Fill the `hosts.yml` with any type of credentials you have
2. Run `make create_user` to create `backend` user, make paswordless sudo and copy ssh keys to user
3. Change `ansible_user` field in hosts to `backend`
4. Run `make setup_deps` to install all required dependencies
5. Create new Parity account for nodes (described below) and populate `./ansible/keys/mainnet/name_of_node` directory
6. Run `make setup_global`. This will:
6.1. Save Docker Compose for DucatusX node in path: `/var/www/ducatusx`. 
6.2. Set persistent files (config, blockchain database, chain configuration) to path: `/var/www/ducatusx-config`
7. SSH to node server, go to node directory (`/var/www/ducatusx`)
8. Run `docker compose up -d`


### Creating new Parity account for nodes

1. Fill `PARITY_WORKER_PATH` in .env with full path of cloned repo on you machine (for example: /home/user/ducatusx)
2. Prepare password for new node - you can use any password generators, create password with 18 characters and without special characters.
    * You can use such command: `< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c\${1:-18};echo;`
3. Run `make create_parity_account.  This command will:
    * Spin up local parity container
    * Request password for new account. Fill generated password here
    * Finally, JSON-file of new account will be saved to `./local_docker_data/ethereum`
4. Run `make put_keys_mainnet node=name_of_node`.
    This command will create directory `./ansible/keys/mainnet/name_of_node` and copy account file (UTC-*) to it
    `name_of_node` - must be identical to name of host in ansible/hosts.yml 
5. Run `sudo chown -R your_user:your_user ansbile/keys/mainnet/name_of_node` to set correct permissions (Docker will set root permissions on generation, and Ansible can struggle with it)
6. Put password from account to file `./ansbile/keys/mainnet/name_of_node/node.pwd`