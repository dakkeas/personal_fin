import pandas as pd
import uuid
from datetime import datetime
import csv
from zoneinfo import ZoneInfo
from google.cloud import bigquery



def main():
    # Example raw_daily_spend data
    # Step 1: Convert raw data to CSV

    raw_daily_spend = "../data/raw_daily_spend.csv"

    # Step 2: Load CSV into a DataFrame
    df = pd.read_csv(raw_daily_spend)

    # Step 3: Append ingestion metadata
    current_time = datetime.now(ZoneInfo("Asia/Manila")).isoformat()
    df['time_ingested'] = current_time
    df['unique_id'] = [str(uuid.uuid4()) for _ in range(len(df))]  # unique ID per row

    # Optional: Save back to CSV with new columns
    df.to_csv("daily_spend_enriched.csv", index=False)

    print(df)

    # BigQuery config
    project_id = "project-23eb5c74-4a49-46c1-a0e"
    table_id = f"{project_id}.personal_finance.daily_spend"

    # Upload to BigQuery
    client = bigquery.Client()
    job = client.load_table_from_dataframe(df, table_id)
    job.result()  # wait for completion

    print(f"Uploaded {job.output_rows} rows to {table_id}")
    


if __name__ = '__main__':
    main()