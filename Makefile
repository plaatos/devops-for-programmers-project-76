# Установка зависимостей Ansible
install_deps:
	ansible-galaxy install -r ansible/requirements.yml

# Подготовка серверов (полная подготовка)
prepare: install_deps
	ansible-playbook -i ansible/inventory.ini playbook.yml

# Деплой Redmine (запуск redmin.yml)
deploy: install_deps
	ansible-playbook -i ansible/inventory.ini redmin.yml

# Полная установка (подготовка + деплой)
full_setup: prepare deploy

# Проверка статуса контейнеров
status:
	ansible all -i ansible/inventory.ini -m shell -a "docker ps -a"

# Логи контейнеров
logs:
	ansible all -i ansible/inventory.ini -m shell -a "docker logs redmine_app"
	ansible all -i ansible/inventory.ini -m shell -a "docker logs redmine_mysql"

# Перезапуск контейнеров
restart:
	ansible all -i ansible/inventory.ini -m community.docker.docker_container -a "name=redmine_app state=restarted"
	ansible all -i ansible/inventory.ini -m community.docker.docker_container -a "name=redmine_mysql state=restarted"

# Быстрая проверка доступности Redmine
test:
	ansible all -i ansible/inventory.ini -m uri -a "url=http://localhost:3000 return_content=yes"