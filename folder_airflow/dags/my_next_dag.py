from airflow import DAG
from airflow.operators.empty import EmptyOperator
from airflow.operators.bash import BashOperator
from datetime import datetime
from airflow.operators.python import PythonOperator
from airflow.providers.postgres.operators.postgres import PostgresOperator


ARGS = {
    "owner": "bmstu",
    "email": ['wzomzot@hop.ru','1@mail.ru'],
    "email_on_failure": True,
    "email_on_retry": False,
    "start_date": datetime(2025, 3, 20),
    "pool": "default_pool",
    "queue": "default"
}


def _xcom_create(**kwargs):
    ti = kwargs['ti']
    ti.xcom_push("some_xcom_key", "100")


def _xcom_get(**kwargs):
    ti = kwargs['ti']
    ti.xcom_push("some_xcom_key_2", int(ti.xcom_pull(key="some_xcom_key")) + int(30))


def _last_xcom(**kwargs):
    ti = kwargs['ti']
    print(ti.xcom_pull(key="some_xcom_key"))
    print(ti.xcom_pull(key="some_xcom_key_2"))


with DAG(dag_id='my_dag_next', # важный атрибут
         default_args=ARGS,
         schedule_interval='0 7 * * *',
         max_active_runs=1,
         catchup=False) as dag:

    t_1 = PythonOperator(
        task_id='xcom_create',
        dag=dag,
        python_callable=_xcom_create
    )

    t_2 = PythonOperator(
        task_id="xcom_get",
        dag=dag,
        python_callable=_xcom_get
    )

    t_3 = PythonOperator(
        task_id="last_xcom",
        dag=dag,
        python_callable=_last_xcom
    )

    run = t_1 >> t_2 >> t_3
