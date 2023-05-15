import requests
import psycopg2
import schedule
import time

# Настройки API amoCRM
API_DOMAIN = 'domen.amocrm.ru'
API_USER = 'login'
API_KEY = 'api_key'

# Настройки базы данных PostgreSQL
DB_HOST = 'localhost'
DB_NAME = 'amo_leads'
DB_USER = 'postgres'
DB_PASSWORD = 'password'

# DDL для создания таблицы amo_leads
DDL = '''
create table if not exists amo_leads (
    id serial primary key
    ,name text not null
    ,status text not null
);
'''

# Создание функции, которая выполняет запрос к API amoCRM, получает список последних сделок и сохраняет их в базу данных
def fetch_leads():
    # Выполняем запрос к API amoCRM
    response = requests.get(f'https://{API_DOMAIN}/api/v2/leads', auth=(API_USER, API_KEY))

    if response.status_code == 200:
        # Получаем список сделок из ответа API
        leads = response.json()['_embedded']['leads']

        # Сохраняем сделки в базу данных
        conn = psycopg2.connect(host=DB_HOST, dbname=DB_NAME, user=DB_USER, password=DB_PASSWORD)
        cursor = conn.cursor()

        for lead in leads:
            name = lead['name']
            status = lead['status_name']
            cursor.execute('insert into amo_leads (name, status) values (%s, %s)', (name, status))

        conn.commit()
        cursor.close()
        conn.close()

# Создание функции, которая выполняет запрос к API amoCRM, получает список сделок и обновляет их статусы в базе данных
def update_leads():
    # Выполняем запрос к API amoCRM
    response = requests.get(f'https://{API_DOMAIN}/api/v2/leads', auth=(API_USER, API_KEY))

    if response.status_code == 200:
        # Получаем список сделок из ответа API
        leads = response.json()['_embedded']['leads']

        # Обновляем статусы сделок в базе данных
        conn = psycopg2.connect(host=DB_HOST, dbname=DB_NAME, user=DB_USER, password=DB_PASSWORD)
        cursor = conn.cursor()

        for lead in leads:
            id = lead['id']
            status = lead['status_name']
            cursor.execute('update amo_leads set status = %s where id = %s', (status, id))

        conn.commit()
        cursor.close()
        conn.close()

# Создание подключение к базе данных и выполнение DDL для создания таблицы amo_leads, если она еще не существует
conn = psycopg2.connect(host=DB_HOST, dbname=DB_NAME, user=DB_USER, password=DB_PASSWORD)
cursor = conn.cursor()
cursor.execute(DDL)
cursor.close()
conn.close()

# Устанавливаем расписание выполнения функций fetch_leads() и update_leads() с заданным интервалом (30 минут и каждую минуту соответственно).
schedule.every(30).minutes.do(fetch_leads)
schedule.every().minutes.do(update_leads)

# Запуск бесконечного цикла, в котором проверяется расписание выполнения задач и выполняются запланированные функции.
while True:
    schedule.run_pending()
    time.sleep(1)