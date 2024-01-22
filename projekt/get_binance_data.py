from binance.client import Client
from dotenv import dotenv_values
import pandas as pd
import datetime

env = dotenv_values('.env')

api_key = env['API_KEY']
api_secret = env['API_SECRET']

client = Client(api_key, api_secret)


def GetHistoricalData(symbol, how_long):
    # Calculate the timestamps for the binance api function
    untilThisDate = datetime.datetime.now()
    sinceThisDate = (untilThisDate - datetime.timedelta(days=how_long)).replace(
        hour=0,
        minute=0,
        second=0,
        microsecond=0,
    )

    # Execute the query from binance - timestamps must be converted to strings !
    candle = client.get_historical_klines(
        symbol,
        Client.KLINE_INTERVAL_1HOUR,
        str(sinceThisDate),
        str(untilThisDate),
    )

    # Create a dataframe to label all the columns returned by binance so we work with them later.
    df = pd.DataFrame(
        candle,
        columns=[
            'dateTime',
            'open',
            'high',
            'low',
            'close',
            'volume',
            'closeTime',
            'quoteAssetVolume',
            'numberOfTrades',
            'takerBuyBaseVol',
            'takerBuyQuoteVol',
            'ignore',
        ],
    )
    # as timestamp is returned in ms, let us convert this back to proper timestamps.
    df.dateTime = pd.to_datetime(
        df.dateTime,
        unit='ms',
        utc=True,
    ).dt.tz_convert('Europe/Warsaw').dt.strftime('%Y-%m-%d %H:%M:%S')
    df.set_index('dateTime', inplace=True)

    # Get rid of columns we do not need
    df = df.drop(
        [
            'closeTime',
            'quoteAssetVolume',
            'numberOfTrades',
            'takerBuyBaseVol',
            'takerBuyQuoteVol',
            'ignore',
        ],
        axis=1,
    )

    df.to_csv(f'binance_data/{symbol}.csv')


codes = [
    'BTCUSDT',
    'ETHUSDT',
    'BNBUSDT',
    'DOGEUSDT',
    'CAKEUSDT',
]

for code in codes:
    GetHistoricalData(code, 7)
