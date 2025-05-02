# - Если файл vault-pass.txt существует → используем --vault-password-file=vault-pass.txt
# - Иначе → запрашиваем пароль вручную (--ask-vault-pass)

ifeq (,$(wildcard vault-pass.txt))
VAULT_PASS = --ask-vault-pass
else
VAULT_PASS = --vault-password-file=vault-pass.txt
endif

# Установка зависимостей Ansible
install_deps:
	ansible-galaxy install -r requirements.yml

# Подготовка серверов (полная подготовка)
prepare: install_deps
	ansible-playbook -i inventory.ini playbook.yml $(VAULT_PASS)

# Деплой Redmine (бывший redmin.yml)
deploy: install_deps
	ansible-playbook -i inventory.ini playbook.yml $(VAULT_PASS) --tags "Развертывание Redmine с MySQL"

# Проверка статуса контейнеров
status:
	ansible all -i inventory.ini -m shell -a "docker ps -a" $(VAULT_PASS)

# Логи контейнеров
logs:
	ansible all -i inventory.ini -m shell -a "docker logs redmine_app" $(VAULT_PASS)
	ansible all -i inventory.ini -m shell -a "docker logs redmine_mysql" $(VAULT_PASS)

# Перезапуск контейнеров
restart:
	ansible all -i inventory.ini -m community.docker.docker_container -a "name=redmine_app state=restarted" $(VAULT_PASS)
	ansible all -i inventory.ini -m community.docker.docker_container -a "name=redmine_mysql state=restarted" $(VAULT_PASS)

# Быстрая проверка доступности Redmine
test:
	ansible all -i inventory.ini -m uri -a "url=http://localhost:3000 return_content=yes" $(VAULT_PASS)

# Зашифровать файл
encrypt_vault:
	ansible-vault encrypt group_vars/webservers/vault.yml

# Расшифровать файл
decrypt_vault:
	ansible-vault decrypt group_vars/webservers/vault.yml

# Редактировать зашифрованный файл
edit_vault:
	ansible-vault edit group_vars/webservers/vault.yml

# Просмотреть зашифрованный файл
view_vault:
	ansible-vault view group_vars/webservers/vault.yml

# Мониторинг
deploy_monitoring: install_deps
	ansible-playbook -i inventory.ini playbook.yml $(VAULT_PASS) --tags "Настройка мониторинга через Datadog"

code-setup:
	ansible-galaxy role install -r requirements.yml

# Полная установка (подготовка + деплой)
full_setup: install_deps
	ansible-playbook -i inventory.ini playbook.yml $(VAULT_PASS) --tags "prepare,redmine,monitoring"

# Очистка контейнеров
clean:
	ansible all -i inventory.ini -m shell -a "docker stop redmine_app redmine_mysql || true" $(VAULT_PASS)
	ansible all -i inventory.ini -m shell -a "docker rm redmine_app redmine_mysql || true" $(VAULT_PASS)