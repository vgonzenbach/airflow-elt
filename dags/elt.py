from datetime import datetime, timedelta
import pendulum
import os
from airflow.decorators import dag
from airflow.operators.dummy_operator import DummyOperator
from airflow.providers.google.cloud.operators.bigquery import BigQueryInsertJobOperator

default_args = {
    'start_date': pendulum.now(),
    'catchup': False,
    'retries': 0,
    'retry_delay': timedelta(minutes=2),
    'depends_on_past': False,
    'email_on_retry': False
}

@dag(
    default_args=default_args,
    description='Load and Transform data in BigQuery with Airflow',
    schedule_interval='@daily'
)
def bigquery_elt(*args, **kwargs): 

    begin = DummyOperator(
        task_id = 'begin'
    )

    insert_output_table = BigQueryInsertJobOperator(
        task_id = 'insert_output_table',
        configuration={
            "query": {
                "query": "{% include 'data/sql/output_table.sql' %}",
                "useLegacySql": False
            }
        },
        location = "EU",
        gcp_conn_id = "google_cloud_default"
    )

    begin >> insert_output_table

dag = bigquery_elt()
