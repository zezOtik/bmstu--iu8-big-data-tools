from airflow import DAG
from airflow.operators.empty import EmptyOperator
from airflow.operators.bash import BashOperator
from datetime import datetime
from airflow.operators.python import PythonOperator


ARGS = {
    "owner": "bmstu",
    "email": ['wzomzot@hop.ru','1@mail.ru'],
    "email_on_failure": True,
    "email_on_retry": False,
    "start_date": datetime(2025, 1, 1),
    "pool": "default_pool",
    "queue": "default"
}


def _xcom_create(**kwargs):
    ti = kwargs['ti']
    ti.xcom_push("our_xml", [1, 2, 3, 4])


def _xcom_get(**kwargs):
    ti = kwargs['ti']
    ti.xcom_push("some_xcom_key_2", "tyt some value")


def _last_xcom(**kwargs):
    ti = kwargs['ti']
    print(ti.xcom_pull(key="our_xml"))


with DAG(dag_id='xcom_test', # важный атрибут
         default_args=ARGS,
         schedule_interval='0 7 * * *',
         max_active_runs=1,
         catchup=False) as dag:

    t_1 = PythonOperator(
        task_id='xcom_create_task',
        dag=dag,
        python_callable=_xcom_create
    )

    t_2 = PythonOperator(
        task_id="xcom_get_task",
        dag=dag,
        python_callable=_xcom_get
    )

    t_3 = PythonOperator(
        task_id="last_xcom_task",
        dag=dag,
        python_callable=_last_xcom
    )

    run = t_1 >> t_2 >> t_3
