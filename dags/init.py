from datetime import datetime, timedelta
from airflow import DAG
from airflow.operators.bash_operator import BashOperator
from airflow.operators.python_operator import PythonOperator
from airflow.utils.dates import days_ago
import os
import smtplib
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart

default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'start_date': days_ago(1),
    'retries': 1,
    'retry_delay': timedelta(minutes=5),
}

dag = DAG(
    'dbt_airflow_sample',
    default_args=default_args,
    description='A simple dbt and Airflow init DAG',
    schedule_interval='@once',
)



# Define dbt commands as bash commands
dbt_install = BashOperator(
    task_id='dbt_install',
    #bash_command='pwd',
   bash_command=' pip install dbt-postgres',
    dag=dag,
)


# Define dbt commands as bash commands
dbt_version = BashOperator(
    task_id='dbt_version',
    #bash_command='pwd',
   bash_command='dbt --version',
    dag=dag,
)

check_directory = BashOperator(
    task_id='check_dbt_directory',
    #bash_command='pwd',
   bash_command='cd /dbt_northwind && ls',
    dag=dag,
)

dbt_debug = BashOperator(
    task_id='test_connection',
    #bash_command='pwd',
   bash_command='cd /dbt_northwind && dbt debug --profiles-dir .',
    dag=dag,
)

dbt_seed = BashOperator(
    task_id='load_csv',
    #bash_command='pwd',
   bash_command='cd /dbt_northwind && dbt seed  --profiles-dir .',
    dag=dag,
)

dbt_run = BashOperator(
    task_id='transform_data',
    #bash_command='pwd',
   bash_command='cd /dbt_northwind && dbt run  --profiles-dir .',
    dag=dag,
)
dbt_test = BashOperator(
    task_id='test',
    #bash_command='pwd',
   bash_command='cd /dbt_northwind && dbt test  --profiles-dir .',
    dag=dag,
)
dbt_install >> dbt_version >> dbt_debug >> check_directory >> dbt_seed >> dbt_run >> dbt_test