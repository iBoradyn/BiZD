import numpy as np
import pandas as pd
import scipy.stats as stats

# Zadanie 1
print('===================Zadanie 1===================')

np.random.seed(0)
sample = np.random.normal(2, 30, 200)

# α=0,05
# H0: średnia = 2.5
# H1: średnia ≠ 2.5
test_result = stats.ttest_1samp(sample, 2.5)

print(test_result)

# Wartość p jest większa od poziomu istotności 0.05, co oznacza,
# że nie ma wystarczających dowodów do odrzucenia hipotezy zerowej.


# Zadanie 2
print()
print('===================Zadanie 2===================')

df = pd.read_csv('napoje.csv', sep=';')

# α=0.05
# H0: średnie spożycie jest równe wartości podanej
# H1: średnie spożycie jest inne niż wartość podana
lech_test = stats.ttest_1samp(df['lech'], 60500)
cola_test = stats.ttest_1samp(df['cola'], 222000)
regionalne_test = stats.ttest_1samp(df['regionalne'], 43500)

print(f'Lech: {lech_test}')
print(f'Cola: {cola_test}')
print(f'Regionalne: {regionalne_test}')

# Dla piwa lech wartość p wynosi 0.101, a więc jest ona większa od poziomu istotności 0.05,
# co oznacza, że nie ma wystarczających dowodów do odrzucenia hipotezy zerowej.

# Dla coli i piwa regionalne wartość p jest bardzo bliska 0,
# dlatego dla tych napojów można odrzucić hipotezę zerową.


# Zadanie 3
print()
print('===================Zadanie 3===================')

for col in df.columns[2:]:
    print(f'{col}: {stats.shapiro(df[col])}')

# Kolumny wykazujące normalność: pepsi, fanta, żywiec, cola, lech
# Kolumna nie wykazująca normalności to piwa regionalne
# Kolumna bliska odrzuceniu hipotezy to okocim


# Zadanie 4
print()
print('===================Zadanie 4===================')

okocim_lech_test = stats.ttest_ind(df['okocim'], df['lech'])
fanta_regionalne_test = stats.ttest_ind(df['fanta '], df['regionalne'])
cola_pepsi_test = stats.ttest_ind(df['cola'], df['pepsi'])

print(f'okocim - lech: {okocim_lech_test}')
print(f'fanta - regionalne: {fanta_regionalne_test}')
print(f'cola - pepsi: {cola_pepsi_test}')

# Okocim - Lech: Wartość p wynosi 0.406, co jest większe niż poziom istotności 0.05.
# Oznacza to, że nie ma wystarczających dowodów do odrzucenia hipotezy o równości średnich.

# Fanta - Regionalne: wartość p jest bardzo bliska 0, co wskazuje na istotne różnice
# między średnimi. Możemy odrzucić hipotezę.

# Cola - Pepsi: Wartość p wynosi 0, co wskazuje na istotne różnice w średnich.
# Możemy odrzucić hipotezę.

# Zadanie 5
print()
print('===================Zadanie 5===================')

okocim_lech_test = stats.levene(df['okocim'], df['lech'])
zywiec_fanta_test = stats.levene(df['żywiec'], df['fanta '])
regionalne_cola_test = stats.levene(df['regionalne'], df['cola'])

print(f'okocim - lech: {okocim_lech_test}')
print(f'zywiec - fanta: {zywiec_fanta_test}')
print(f'regionalne - cola: {regionalne_cola_test}')

# Okocim - Lech: Wartość p wynosi 0.276, co jest wyższe niż poziom istotności 0.05,
# oznacza to brak wystarczających dowodów do odrzucenia hipotezy o równości wariancji.

# Żywiec - Fanta: Wartość p wynosi 0.225, co również wskazuje na brak dowodów
# przeciwko równości wariancji.

# Regionalne - Cola: Wartość p jest bardzo bliska 0, co wskazuje na istotne
# różnice w wariancjach. Można stwierdzić, że wariancje tych dwóch napojów są różne.
# Możemy odrzucić hipotezę.


# Zadanie 6
print()
print('===================Zadanie 6===================')

regionalne_2001 = df[df['rok'] == 2001]['regionalne']
regionalne_2015 = df[df['rok'] == 2015]['regionalne']

regionalne_2001_2015_test = stats.ttest_ind(regionalne_2001, regionalne_2015, equal_var=False)

print(regionalne_2001_2015_test)

# Wartość p jest mniejsza niż poziom istotności 0.05, co wskazuje na istotne
# różnice między średnimi sprzedaży piw regionalnych w latach 2001 i 2015.
# Możemy odrzucić hipotezę.


# Zadanie 7
print()
print('===================Zadanie 7===================')

df_after_commercials = pd.read_csv('napoje_po_reklamie.csv', sep=';')
df_2016 = df[df['rok'] == 2016]

cola_test = stats.ttest_rel(df_2016['cola'], df_after_commercials['cola'])
fanta_test = stats.ttest_rel(df_2016['fanta '], df_after_commercials['fanta '])
pepsi_test = stats.ttest_rel(df_2016['pepsi'], df_after_commercials['pepsi'])

print(f'cola: {cola_test}')
print(f'fanta: {fanta_test}')
print(f'pepsi: {pepsi_test}')

# Wartości p dla wszystkich trzech napojów są znacznie wyższe niż poziom istotności 0.05,
# co oznacza, że nie ma wystarczających dowodów do odrzucenia hipotez o równości średnich.
