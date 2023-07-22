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

def handle_failure(context):
    # This function will be called whenever a task fails in the DAG
    failed_task = context.get('task_instance')
    failed_task_id = failed_task.task_id

    # Perform actions or create additional tasks specific to handling failure scenarios
    # For example, you can send a notification, trigger a recovery process, or perform cleanup tasks.

    # Send a notification
    send_notification()


def send_notification():
    # Email configuration
    sender_email = 'savindukoshitha.a@gmail.com'
    recipient_email = 'koshithaa@n-able.biz'
    smtp_server = 'smtp.gmail.com'
    smtp_port = 587
    smtp_username = 'savindukoshitha.a@gmail.com'
    smtp_password = ''

    # Email content
    subject = 'Airflow DAG Execution Failure'
    body = 'An error occurred while executing the DAG. Please check the logs for more details.'

    # Construct the email message
    message = MIMEMultipart()
    message['From'] = sender_email
    message['To'] = recipient_email
    message['Subject'] = subject
    message.attach(MIMEText(body, 'plain'))

    # Send the email
    try:
        with smtplib.SMTP(smtp_server, smtp_port) as server:
            server.starttls()
            server.login(smtp_username, smtp_password)
            server.send_message(message)
        print('Email notification sent successfully!')
    except Exception as e:
        print(f'Failed to send email notification. Error: {str(e)}')


dag = DAG(
    'dbt_airflow_sample',
    default_args=default_args,
    description='A simple dbt and Airflow init DAG',
    schedule_interval='@once',
    on_failure_callback=handle_failure,  # Specify the failure handling function
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
    #bash_command='dbt --version',
    bash_command=' cd /dbt_northwind && dbt deps && dbt seed  --profiles-dir .',
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