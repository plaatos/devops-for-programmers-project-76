# DevOps Project: Redmine Deployment

[![hexlet-check](https://github.com/plaatos/devops-for-programmers-project-76/actions/workflows/hexlet-check.yml/badge.svg)](https://github.com/plaatos/devops-for-programmers-project-76/actions/workflows/hexlet-check.yml)

## Описание проекта
Этот проект предоставляет автоматизированное развертывание Redmine с использованием Ansible и Docker. Включает настройку мониторинга через Datadog.

Приложение доступно по адресу: [https://test-step.ru/](https://test-step.ru/)

---

## Подготовка серверов
1. Установите зависимости:  
   ```bash
   make install_deps
   ```
2. Запустите подготовку серверов:  
   ```bash
   make prepare
   ```

---

## Переменные
- `ansible/inventory.ini`: укажите реальные IP-адреса серверов:
  - `server-1`: `89.169.149.234`
  - `server-2`: `158.160.102.161`

---

## Команды Makefile

### Управление зависимостями
```bash
make install_deps       # Установка зависимостей Ansible
```

### Подготовка и деплой
```bash
make prepare            # Подготовка серверов
make deploy             # Деплой Redmine
make full_setup         # Полная установка (подготовка + деплой)
```

### Мониторинг контейнеров
```bash
make status             # Проверка статуса контейнеров
make logs               # Просмотр логов контейнеров
make restart            # Перезапуск контейнеров
```

### Работа с Ansible Vault
```bash
make encrypt_vault      # Зашифровать файл vault.yml
make decrypt_vault      # Расшифровать файл vault.yml
make edit_vault         # Редактировать зашифрованный файл
make view_vault         # Просмотреть зашифрованный файл
```

### Настройка мониторинга
```bash
make deploy_monitoring  # Установка и настройка Datadog
```

---

## Мониторинг
Проект включает настройку мониторинга через Datadog. Агент Datadog выполняет HTTP-проверки доступности Redmine по адресу `http://localhost:3000`.

---

## Безопасность
- Секретные данные хранятся в зашифрованном виде в файле `ansible/group_vars/vault.yml`.
- Для дешифровки используется команда `ansible-vault`. Пароль для дешифровки не включен в репозиторий.


