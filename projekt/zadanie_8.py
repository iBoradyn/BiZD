import pandas as pd
import matplotlib.pyplot as plt
import mplfinance as mpf
import psycopg2
from dotenv import dotenv_values

env = dotenv_values('.env')

conn = psycopg2.connect(
    dbname=env['DATABASE_NAME'],
    user=env['DATABASE_USERNAME'],
    password=env['DATABASE_PASSWORD'],
    host=env['DATABASE_HOST'],
)

codes = {
    1: 'BTCUSDT',
    2: 'BNBUSDT',
    3: 'ETHUSDT',
    4: 'DOGEUSDT',
    5: 'CAKEUSDT',
}

try:
    query = 'SELECT * FROM daily_exchange_summary'
    df = pd.read_sql(query, conn)

    for code_id, code in codes.items():
        sub_df = df[df['code_id'] == code_id]
        sub_df['day'] = pd.to_datetime(df['day'])
        sub_df.set_index('day', inplace=True)
        sub_df = sub_df[[
            'avg_open',
            'avg_high',
            'avg_low',
            'avg_close',
            'total_volume',
        ]]
        sub_df.columns = [
            'Open',
            'High',
            'Low',
            'Close',
            'Volume',
        ]
        mpf.plot(
            sub_df,
            type='candle',
            volume=True,
            style='yahoo',
            title=f'Średnie wartości cenowe {code}',
        )

        plt.tight_layout()
        plt.show()

except Exception as e:
    print(f"Wystąpił błąd: {e}")
finally:
    conn.close()
