prepare: install_deps
	ansible-playbook -i ansible/inventory.ini playbook.yml

install_deps:
	ansible-galaxy install -r ansible/requirements.yml
