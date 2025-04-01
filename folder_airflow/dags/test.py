from airflow import DAG
from airflow.operators.empty import EmptyOperator
from airflow.operators.bash import BashOperator
from datetime import datetime
from airflow.operators.python import PythonOperator
from airflow.providers.common.sql.operators.sql import SQLExecuteQueryOperator


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
    "start_date": datetime(2025, 3, 20), # важный атрибут
    "pool": "default_pool",
    "queue": "default"
}


with DAG(dag_id='test_dag_1', # важный атрибут
         default_args=ARGS,
         schedule_interval='0 7 * * *',
         max_active_runs=1,
         catchup=True) as dag:

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
        bash_command="echo {{ logical_date.replace(day=1).strftime('%d/%m/%Y') }}",
        dag=dag
    )

    t4 = EmptyOperator(
        task_id='end',
        dag=dag
    )

    run = t1 >> [t2, t3] >> t4


# with DAG(dag_id='test_pgsql_dag', # важный атрибут
#          default_args=ARGS,
#          schedule_interval='0 7 * * *',
#          max_active_runs=1,
#          catchup=False) as dag:
#
#     t1 = SQLExecuteQueryOperator(
#         task_id="pgsql_task",
#         sql="select version()",
#         conn_id="SQL_ALCHEMY_CONN"
#     )