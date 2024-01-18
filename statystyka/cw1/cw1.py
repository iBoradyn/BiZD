import pandas as pd
import statistics
import scipy.stats as stats
import matplotlib.pyplot as plt

# Zadanie 1
print('===================Zadanie 1===================')

df = pd.read_csv('MDR_RR_TB_burden_estimates_2024-01-18.csv')
e_rr_pct_ret = df['e_rr_pct_ret']
print(e_rr_pct_ret.describe())


# Zadanie 2
print()
print('===================Zadanie 2===================')

df = pd.read_csv('Wzrost.csv')
values_list = df.columns.astype(float).tolist()

variance = statistics.variance(values_list)
std_dev = statistics.stdev(values_list)

print(f'Wariacja: {variance}')
print(f'Odchylenie standardowe: {std_dev}')

# variance() - Mierzy jak bardzo poszczególne wartości w zbiorze danych różnią się od średniej.
# stdev() - Jest to pierwiastek kwadratowy z wariancji.
# Odchylenie standardowe również mierzy rozproszenie danych, ale jest w tych samych jednostkach
# co dane, co czyni je bardziej intuicyjnym w interpretacji.


# Zadanie 3
print()
print('===================Zadanie 3===================')

df = pd.read_csv('napoje.csv', sep=';')

pepsi_stats = stats.describe(df['pepsi'])
print(f'Podstawowe statystyki dla napoju pepsi:\n{pepsi_stats}')

# Moduł scipy.stats zawiera wiele funkcji do statystyk opisowych,
# ich lista z opisami znajduje się pod linkiem:
# https://docs.scipy.org/doc/scipy/reference/stats.html#summary-statistics


# Zadanie 4
df = pd.read_csv('brain_size.csv', sep=';')
plt.figure(figsize=(15, 5))

plt.subplot(1, 3, 1)
plt.hist(df['VIQ'].dropna(), bins=10, color='blue', alpha=0.7)
plt.title('VIQ')

plt.subplot(1, 3, 2)
plt.hist(df['PIQ'].dropna(), bins=10, color='green', alpha=0.7)
plt.title('PIQ')

plt.subplot(1, 3, 3)
plt.hist(df['FSIQ'].dropna(), bins=10, color='red', alpha=0.7)
plt.title('FSIQ')

plt.tight_layout()
plt.show()

df_women = df[df['Gender'] == 'Female']
plt.figure(figsize=(15, 5))

plt.subplot(1, 3, 1)
plt.hist(df_women['VIQ'].dropna(), bins=10, color='blue', alpha=0.7)
plt.title('VIQ (Kobiety)')

plt.subplot(1, 3, 2)
plt.hist(df_women['PIQ'].dropna(), bins=10, color='green', alpha=0.7)
plt.title('PIQ (Kobiety)')

plt.subplot(1, 3, 3)
plt.hist(df_women['FSIQ'].dropna(), bins=10, color='red', alpha=0.7)
plt.title('FSIQ (Kobiety)')

plt.tight_layout()
plt.show()
