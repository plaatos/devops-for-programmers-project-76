# Установка зависимостей Ansible
install_deps:
	ansible-galaxy install -r requirements.yml

# Подготовка серверов (полная подготовка)
prepare: install_deps
	ansible-playbook -i inventory.ini playbook.yml --ask-vault-pass

# Деплой Redmine (бывший redmin.yml)
deploy: install_deps
	ansible-playbook -i inventory.ini playbook.yml --ask-vault-pass --tags "Развертывание Redmine с MySQL"

# Проверка статуса контейнеров
status:
	ansible all -i inventory.ini -m shell -a "docker ps -a" --ask-vault-pass

# Логи контейнеров
logs:
	ansible all -i inventory.ini -m shell -a "docker logs redmine_app" --ask-vault-pass
	ansible all -i inventory.ini -m shell -a "docker logs redmine_mysql" --ask-vault-pass

# Перезапуск контейнеров
restart:
	ansible all -i inventory.ini -m community.docker.docker_container -a "name=redmine_app state=restarted" --ask-vault-pass
	ansible all -i inventory.ini -m community.docker.docker_container -a "name=redmine_mysql state=restarted" --ask-vault-pass

# Быстрая проверка доступности Redmine
test:
	ansible all -i inventory.ini -m uri -a "url=http://localhost:3000 return_content=yes" --ask-vault-pass

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
	ansible-playbook -i inventory.ini playbook.yml --ask-vault-pass --tags "Настройка мониторинга через Datadog"

code-setup:
	ansible-galaxy role install -r requirements.yml

# Полная установка (подготовка + деплой)
full_setup: install_deps
	ansible-playbook -i inventory.ini playbook.yml --ask-vault-pass --tags "prepare,redmine,monitoring"

# Очистка контейнеров
clean:
	ansible all -i inventory.ini -m shell -a "docker stop redmine_app redmine_mysql || true" --ask-vault-pass
	ansible all -i inventory.ini -m shell -a "docker rm redmine_app redmine_mysql || true" --ask-vault-pass