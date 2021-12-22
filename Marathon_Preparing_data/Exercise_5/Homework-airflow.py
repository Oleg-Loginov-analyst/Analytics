from datetime import datetime, timedelta
from textwrap import dedent
from airflow import DAG
from airflow.operators.bash import BashOperator
from airflow.operators.python import PythonOperator
from airflow.utils.dates import days_ago

default_args = {
    'owner': 'oleg',
    'depends_on_past': False,
    'email': ['airflow@example.com'],
    'email_on_failure': False,
    'email_on_retry': False,
    'retries': 1,
    'retry_delay': timedelta(minutes=5)
}

def hello_world():
    print('Hello Airflow from Python')

with DAG(
    'my_test_dag',
    default_args      = default_args,
    description       = 'my first test DAG',
    schedule_interval = '0 3 * */1 1,3,5',
    start_date        = days_ago(2),
    tags              = ['example', 'test'],
) as dag:

    bash_1 = BashOperator(
        task_id = 'bash_id_1',
        bash_command = "echo Hello Airflow from Bash"
    )

    bash_2 = BashOperator(
        task_id = 'bash_id_2',
        bash_command = "echo Hello Airflow again from Bash"
    )

    python_1 = PythonOperator(
        task_id ='python_id_1',
        python_callable = hello_world
    )

    python_2 = PythonOperator(
        task_id = 'python_id_2',
        python_callable = hello_world
    )

    bash_1 >> [python_1, python_2] >> bash_2