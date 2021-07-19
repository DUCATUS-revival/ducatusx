#callback := ANSIBLE_STDOUT_CALLBACK=debug
hosts_path := ansible/hosts.yml
service := all
verbosity := 

ansible_cfg := ANSIBLE_CONFIG=$(shell pwd)/ansible/ansible.cfg


# ------ #
# Install dependencies

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
