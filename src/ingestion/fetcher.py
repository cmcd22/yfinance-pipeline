import s3_client
import yfinance as yf
import os

bucket = os.environ["BRONZE_BUCKET"]


def fetch_data(ticker):
    df = yf.Ticker(ticker).quarterly_financials
    string_columns = df.columns.strftime('%Y-%m-%d').tolist()
    for column in string_columns:
        prefix = f"ticker={ticker}/quarter_end={column}"
        if not s3_client.s3_bucket_data_check(bucket, prefix):
            json_data = df[column].to_json(orient='index')
            s3_client.write_to_s3(json_data, bucket, ticker, column)
