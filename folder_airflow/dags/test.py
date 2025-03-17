from airflow import DAG
from airflow.operators.empty import EmptyOperator
from datetime import datetime


ARGS = {
    "owner": "MZ",
    "email": ['MZ'],
    "email_on_failure": True,
    "email_on_retry": False,
    "start_date": datetime(2024, 1, 1),
    "pool": "default",
    "queue": "default"
}


with DAG(dag_id='test_dag',
         default_args=ARGS,
         schedule_interval='0 7 * * *',
         max_active_runs=1,
         catchup=False) as dag:
    t1 = EmptyOperator(
        task_id='start_task',
        dag=dag
    )
    run = t1

