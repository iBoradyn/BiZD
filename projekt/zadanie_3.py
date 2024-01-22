import pandas as pd

codes = [
    'BTCUSDT',
    'ETHUSDT',
    'BNBUSDT',
    'DOGEUSDT',
    'CAKEUSDT',
]

for code in codes:
    df = pd.read_csv(f'binance_data/{code}.csv')

    print(f'Statystyki opisowe zbioru {code}:')
    print(df.describe())
    print()
