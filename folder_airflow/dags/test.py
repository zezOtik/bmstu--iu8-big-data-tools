from airflow import DAG
from airflow.operators.empty import EmptyOperator
from airflow.operators.bash import BashOperator
from datetime import datetime
from airflow.operators.python import PythonOperator


def ty_tyt():
    print("ya tochno tyt")
    pass


def print_text():
    print("ya tyt")
    ty_tyt()
    pass


ARGS = {
    "owner": "bmstu",
    "email": ['wzomzot@hop.ru','1@mail.ru'],
    "email_on_failure": True,
    "email_on_retry": False,
    "start_date": datetime(2024, 1, 1), # важный атрибут
    "pool": "default_pool",
    "queue": "default"
}


with DAG(dag_id='test_dag_1', # важный атрибут
         default_args=ARGS,
         schedule_interval='0 7 * * *',
         max_active_runs=1,
         catchup=False) as dag:

    t1 = EmptyOperator(
        task_id='start',
        dag=dag
    )

    t2 = PythonOperator(
        task_id='start_task_2',
        dag=dag,
        python_callable=print_text
    )

    t3 = BashOperator(
        task_id='bash_task',
        bash_command='echo 777',
        dag=dag
    )

    t4 = EmptyOperator(
        task_id='end',
        dag=dag
    )

    run = t1 >> [t2, t3] >> t4

