import config
import fetcher


def lambda_handler(event, context):
    tickers_list = config.tickers
    for ticker in tickers_list:
        try:
            fetcher.fetch_data(ticker)
        except Exception as e:
            print(f"Error caught from ticker {ticker}: {e}")
