
from google.cloud import bigquery
import os

os.environ['GOOGLE_APPLICATION_CREDENTIALS'] = r'../service-account.json'

# Initialize BigQuery client
client = bigquery.Client()

TABLE_ID = "project-23eb5c74-4a49-46c1-a0e.personal_finance.raw_daily_spend"


def load_to_bigquery(dataframe):
    print('dataframe!')
    job = client.load_table_from_dataframe(dataframe, TABLE_ID)

    job.result()  # Wait for the job to finish

    print(f"Loaded {job.output_rows} rows to {TABLE_ID}")

    


        