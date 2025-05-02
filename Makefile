# Makefile — простой и безопасный для локальной работы

VAULT_PASS = --ask-vault-pass

install_deps:
	ansible-galaxy install -r requirements.yml

prepare: install_deps
	ansible-playbook -i inventory.ini playbook.yml $(VAULT_PASS)

deploy: install_deps
	ansible-playbook -i inventory.ini playbook.yml $(VAULT_PASS) --tags "Развертывание Redmine с MySQL"

status:
	ansible all -i inventory.ini -m shell -a "docker ps -a" $(VAULT_PASS)

logs:
	ansible all -i inventory.ini -m shell -a "docker logs redmine_app" $(VAULT_PASS)
	ansible all -i inventory.ini -m shell -a "docker logs redmine_mysql" $(VAULT_PASS)

restart:
	ansible all -i inventory.ini -m community.docker.docker_container -a "name=redmine_app state=restarted" $(VAULT_PASS)
	ansible all -i inventory.ini -m community.docker.docker_container -a "name=redmine_mysql state=restarted" $(VAULT_PASS)

test:
	ansible all -i inventory.ini -m uri -a "url=http://localhost:3000 return_content=yes" $(VAULT_PASS)

encrypt_vault:
	ansible-vault encrypt group_vars/webservers/vault.yml

decrypt_vault:
	ansible-vault decrypt group_vars/webservers/vault.yml

edit_vault:
	ansible-vault edit group_vars/webservers/vault.yml

view_vault:
	ansible-vault view group_vars/webservers/vault.yml

deploy_monitoring: install_deps
	ansible-playbook -i inventory.ini playbook.yml $(VAULT_PASS) --tags "Настройка мониторинга через Datadog"

code-setup:
	ansible-galaxy role install -r requirements.yml

full_setup: install_deps
	ansible-playbook -i inventory.ini playbook.yml $(VAULT_PASS) --tags "prepare,redmine,monitoring"

clean:
	ansible all -i inventory.ini -m shell -a "docker stop redmine_app redmine_mysql || true" $(VAULT_PASS)
	ansible all -i inventory.ini -m shell -a "docker rm redmine_app redmine_mysql || true" $(VAULT_PASS)