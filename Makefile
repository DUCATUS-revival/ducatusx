#callback := ANSIBLE_STDOUT_CALLBACK=debug
hosts_path := ansible/hosts.yml
service := all
verbosity := 

ansible_cfg := ANSIBLE_CONFIG=$(shell pwd)/ansible/ansible.cfg

local_parity_compose := keys-compose.yml


# ------ #
# Install dependencies
# Setup users
create_user:
	$(ansible_cfg) ansible-playbook -i=$(hosts_path) -l $(service) ansible/tasks/create-user.yml $(verbosity)



# All nodes if w/o service or selected node by ansible hostname
setup_deps:
	$(ansible_cfg) ansible-playbook -i=$(hosts_path) -l $(service) ansible/tasks/global-install-deps.yml $(verbosity)

# ------ #
# Sync files and configuration

# All nodes if w/o service or selected node by ansible hostname
setup_global:
	$(ansible_cfg) ansible-playbook -i=$(hosts_path) -l $(service) ansible/tasks/global-sync-configure.yml $(verbosity)


# ------ #
# Docker orchestration to all nodes if w/o service or selected node by ansible hostname

docker_build:
	$(ansible_cfg) ansible-playbook -i=$(hosts_path) -l $(service) ansible/tasks/compose/build.yml $(verbosity)

docker_start:
	$(ansible_cfg) ansible-playbook -i=$(hosts_path) -l $(service) ansible/tasks/compose/start.yml $(verbosity)

docker_stop:
	$(ansible_cfg) ansible-playbook -i=$(hosts_path) -l $(service) ansible/tasks/compose/stop.yml $(verbosity)

docker_destroy:
	$(ansible_cfg) ansible-playbook -i=$(hosts_path) -l $(service) ansible/tasks/compose/destroy.yml $(verbosity)

# ------ #
# Configuration update (predefined group)

update: setup_global docker_build


# ------ #
# Create new parity account with keys
create_parity_account:
	sudo docker-compose -f  $(local_parity_compose) up -d
	sudo docker-compose -f  $(local_parity_compose) exec ducatusx parity account new
	sudo docker-compose -f  $(local_parity_compose) exec ducatusx cp -r /root/.local/share/io.parity.ethereum/keys/ethereum/ /temp_data/
	sudo docker-compose down

put_keys_mainnet:
	mkdir -p ansible/keys/mainnet/$(node)/keys/DUCX_main
	sudo mv local_docker_data/ethereum/UTC* ansible/keys/mainnet/$(node)/keys/DUCX_main
	sudo rm -rf local_docker_data/ethereum
