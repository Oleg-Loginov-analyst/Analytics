# Устанавливал на Windows 11 через WSL (виртуальная Ubuntu для Windows) используя Docker и docker-compose

1. Устанавливаем WSL через консоль

2. Скачиваем <a href="https://www.docker.com/products/docker-desktop/">Docker Desktop</a>

3. Перед установкой Airflow проверьте, что у вас хватает оперативной памятия для его установки. Нужно мимнимум 4GB, в идеале - 8GB. Проверить достаточно ли у вас оперативной памяти можно с помощью команды `docker run --rm "debian:bullseye-slim" bash -c 'numfmt --to iec $(echo $(($(getconf _PHYS_PAGES) * $(getconf PAGE_SIZE))))'`

4. Если с оперативной памятью все ок, то скачиваем файл docker-compose.yaml с помощью этой команды `curl -LfO 'https://airflow.apache.org/docs/apache-airflow/2.5.0/docker-compose.yaml'`

5. Файл docker-compose.yaml содержит внутри себя несколько сервисов:
* airflow-scheduler — планировщик отслеживает все задачи и DAG, а затем запускает экземпляры задач после завершения их зависимостей;
* airflow-webserver — веб-сервер доступен по адресу `http://localhost:8080`
* airflow-worker — выполняет задачи, заданные планировщиком;
* airflow-init — служба инициализации;
* postgres - база данных;
* redis — брокер, который пересылает сообщения от планировщика к воркеру.

6. После установки Airflow нужно выполнить миграцию базы данных и создать первую учетную запись пользователя. Для этого выполните команду `docker compose up airflow-init`

7. Посл окончания инициализации созданная учетная запись будет иметь логин — airflow и пароль — airflow;

8. Запускаем Airflow командой `docker-compose up`. Начнут подниматься контейнеры. Контейнеры можно увидеть в интерфейсе Docker Desktop или набрав в консоли команду `docker ps`

9. После запуска кластера можно войти в веб-интерфейс Airflow. Веб-сервер доступен по адресу `http://localhost:8080`