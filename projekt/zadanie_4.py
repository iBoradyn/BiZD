from pprint import pprint

from scipy.stats import shapiro, levene, kruskal
import pandas as pd

codes = [
    'BTCUSDT',
    'ETHUSDT',
    'BNBUSDT',
    'DOGEUSDT',
    'CAKEUSDT',
]
testing_column = 'open'

dfs = {code: pd.read_csv(f'binance_data/{code}.csv') for code in codes}

# Poniżej zostały przeprowadzone testy sprawdzające normalnośc rozkładów dla poszczególnych zbiorów,
# a także równość wariacji oraz równość median między wybranymi kryptowalutami w badanej kolumnie.
# Przyjmowany poziom istatności dla testów: 0.05

print(f'Badana kolumna: {testing_column}')
print()

print('Testy Shapiro-Wilka na normalność rozkładu w poszczególnych zbiorach:')
shapiro_results = {code: shapiro(df[testing_column]) for code, df in dfs.items()}
pprint(shapiro_results)
print()

print('Test Levenea na równość wariacji między różnymi kryptowalutami:')
btc_eth = levene(dfs['BTCUSDT'][testing_column], dfs['ETHUSDT'][testing_column])
btc_bnb = levene(dfs['BTCUSDT'][testing_column], dfs['BNBUSDT'][testing_column])
eth_bnb = levene(dfs['ETHUSDT'][testing_column], dfs['BNBUSDT'][testing_column])
eth_doge = levene(dfs['ETHUSDT'][testing_column], dfs['DOGEUSDT'][testing_column])
eth_cake = levene(dfs['ETHUSDT'][testing_column], dfs['CAKEUSDT'][testing_column])
cake_doge = levene(dfs['CAKEUSDT'][testing_column], dfs['DOGEUSDT'][testing_column])
print(f'BTC - ETH: {btc_eth}')
print(f'BTC - BNB: {btc_bnb}')
print(f'ETH - BNB: {eth_bnb}')
print(f'ETH - DOGE: {eth_doge}')
print(f'ETH - CAKE: {eth_cake}')
print(f'CAKE - DOGE: {cake_doge}')
print()

print('Test Kruskala-Wallisa na równość median między różnymi kryptowalutami:')
btc_eth = kruskal(dfs['BTCUSDT'][testing_column], dfs['ETHUSDT'][testing_column])
btc_bnb = kruskal(dfs['BTCUSDT'][testing_column], dfs['BNBUSDT'][testing_column])
eth_bnb = kruskal(dfs['ETHUSDT'][testing_column], dfs['BNBUSDT'][testing_column])
eth_doge = kruskal(dfs['ETHUSDT'][testing_column], dfs['DOGEUSDT'][testing_column])
eth_cake = kruskal(dfs['ETHUSDT'][testing_column], dfs['CAKEUSDT'][testing_column])
cake_doge = kruskal(dfs['CAKEUSDT'][testing_column], dfs['DOGEUSDT'][testing_column])
print(f'BTC - ETH: {btc_eth}')
print(f'BTC - BNB: {btc_bnb}')
print(f'ETH - BNB: {eth_bnb}')
print(f'ETH - DOGE: {eth_doge}')
print(f'ETH - CAKE: {eth_cake}')
print(f'CAKE - DOGE: {cake_doge}')
print()
print()

# Powyższe testy wskazują, że w każdym ze zbiorów są podstawy do odrzucenia hipotezy o
# normalności rozkładu. Można także odrzucić hipotezy o równości wariacji oraz równości między
# wybranymi wyżej kryptowalutami.

for code in codes:
    print(f'Badanie korelacji między kolumnami w zbiorze {code}')
    open_volume = dfs[code]['open'].corr(dfs[code]['volume'], method='spearman')
    volume_close = dfs[code]['volume'].corr(dfs[code]['close'], method='spearman')
    print(f'Korelacja między ceną otwierającą, a ilością sprzedaży: {open_volume}')
    print(f'Korelacja między ilością sprzedaży, a ceną zamykającą: {volume_close}')
    print()

# Badanie korelacji wykazało słabą zależność monotoniczną między ceną otwierającą, a sprzedaną
# ilością oraz sprzedną ilością, a ceną zamykającą. Największe współczynniki korelacji
# wystąpiły przy sprzedaży mniej cennych kryptowalut, tzn. Dogecoin(DOGE) i PancakeSwap(CAKE),
# wśród trzech dużo cenniejszych kryptowalut tylko przy Ethereum(ETH) ten współczynnik jest
# na podobnym poziomie.





