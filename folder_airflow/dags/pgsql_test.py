from airflow import DAG
from airflow.operators.empty import EmptyOperator
from airflow.operators.bash import BashOperator
from datetime import datetime
from airflow.operators.python import PythonOperator
from airflow.providers.common.sql.operators.sql import SQLExecuteQueryOperator
# from airflow.providers.postgres.operators.postgres import PostgresOperator


ARGS = {
    "owner": "bmstu",
    "email_on_failure": True,
    "email_on_retry": False,
    "start_date": datetime(2025, 3, 20), # важный атрибут
    "pool": "default_pool",
    "queue": "default"
}


with DAG(dag_id='pgsql_dag', # важный атрибут
         default_args=ARGS,
         schedule_interval='0 7 * * *',
         max_active_runs=1,
         catchup=False) as dag:

    t_1 = SQLExecuteQueryOperator(
        task_id='pgsql_create_schema',
        dag=dag,
        conn_id="test_airflow_conn",
        sql="CREATE SCHEMA IF NOT EXISTS api_result;",
        show_return_value_in_logs=True
    )

    t_2 = SQLExecuteQueryOperator(
        task_id='pgsql_create_table',
        dag=dag,
        conn_id="test_airflow_conn",
        sql="CREATE TABLE IF NOT EXISTS api_result.currencies("
            "dttm timestamp,"
            "currency_code text,"
            "created_dttm timestamp);",
        show_return_value_in_logs=True
    )

    run = t_1 >> t_2
