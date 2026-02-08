import os
import io
import pandas as pd
import uuid
from datetime import datetime
from zoneinfo import ZoneInfo
from google.auth.transport.requests import Request
from google.oauth2.credentials import Credentials
from google_auth_oauthlib.flow import InstalledAppFlow
from googleapiclient.discovery import build
from googleapiclient.errors import HttpError
from googleapiclient.http import MediaIoBaseDownload
from ingest_to_bigquery import *
import hashlib




# OUTPUT_FILE = r"C:\Users\justi\Documents\coding-projects\personal_fin\data\raw_daily_spend.csv"


SCOPES = ["https://www.googleapis.com/auth/drive.readonly"]
TOKEN_PATH = r"C:\Users\justi\Documents\coding-projects\personal_fin\secret\token.json"
CREDENTIALS_PATH = r"C:\Users\justi\Documents\coding-projects\personal_fin\secret\credentials.json"
# FILE_ID = "YOUR_FILE_ID_HERE"
FILE_ID = "1-14lEgH2wXQhY67mXnCgobYMVhrTfZZTbUO7w-ymvbM"


def main():
    creds = None

    # Load existing token
    if os.path.exists(TOKEN_PATH):
        creds = Credentials.from_authorized_user_file(TOKEN_PATH, SCOPES)

    # If no valid creds, login once
    if not creds or not creds.valid:
        if creds and creds.expired and creds.refresh_token:
            creds.refresh(Request())
        else:
            flow = InstalledAppFlow.from_client_secrets_file(
                CREDENTIALS_PATH, SCOPES
            )
            creds = flow.run_local_server(port=0)

        with open(TOKEN_PATH, "w") as token:
            token.write(creds.to_json())

    try:
        service = build("drive", "v3", credentials=creds)

        request = service.files().export_media(
            fileId=FILE_ID,
            mimeType="text/csv"
        )

        # Download into memory (not file)
        fh = io.BytesIO()
        downloader = MediaIoBaseDownload(fh, request)
        done = False

        while not done:
            status, done = downloader.next_chunk()
            print(f"Download {int(status.progress() * 100)}%")

        fh.seek(0)

        # Convert to DataFrame
        df = pd.read_csv(fh)

        print("DataFrame loaded successfully:")
        
        current_time = datetime.now(ZoneInfo("Asia/Manila")).isoformat()
        df['time_ingested'] = current_time
        df['unique_id'] = [str(uuid.uuid4()) for _ in range(len(df))]  # unique ID per row

        columns_to_hash = ['date', 'day', 'lineitem', 'type', 'subtype', 'total_cost', 'payment_type']
        
        def compute_hash(row):
            # Convert each column to string, join with '|', compute MD5 hash
            row_str = '|'.join([str(row[col]) for col in columns_to_hash])
            return hashlib.md5(row_str.encode('utf-8')).hexdigest()

        df['hash_key'] = df.apply(compute_hash, axis=1)

        print(df.head())
        # ingest to bigquery
        load_to_bigquery(df)

    except HttpError as error:
        print(f"An error occurred: {error}")


if __name__ == "__main__":
    main()
