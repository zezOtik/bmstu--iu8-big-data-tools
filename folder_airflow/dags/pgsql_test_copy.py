from airflow import DAG
from airflow.operators.empty import EmptyOperator
from airflow.operators.bash import BashOperator
from datetime import datetime
from airflow.operators.python import PythonOperator
# from airflow.providers.common.sql.operators.sql import SQLExecuteQueryOperator
from airflow.providers.postgres.operators.postgres import PostgresOperator


ARGS = {
    "owner": "bmstu",
    "email_on_failure": True,
    "email_on_retry": False,
    "start_date": datetime(2025, 3, 20), # важный атрибут
    "pool": "default_pool",
    "queue": "default"
}


with DAG(dag_id='pgsql_dag_another', # важный атрибут
         default_args=ARGS,
         schedule_interval='0 7 * * *',
         max_active_runs=1,
         catchup=False) as dag:

    t_1 = PostgresOperator(
        task_id='pgsql_create_schema',
        dag=dag,
        postgres_conn_id="test_airflow_conn",
        sql="CREATE SCHEMA IF NOT EXISTS test_another;"
    )

    t_2 = PostgresOperator(
        task_id='pgsql_create_table',
        dag=dag,
        postgres_conn_id="test_airflow_conn",
        sql="""CREATE TABLE IF NOT EXISTS test_another.test_table(
            id bigint,
            dttm timestamp
            );"""
    )

    run = t_1 >> t_2
