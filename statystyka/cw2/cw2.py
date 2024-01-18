import numpy as np
import scipy.stats as stats
import matplotlib.pyplot as plt
import seaborn as sns

# Zadanie 1
print('===================Zadanie 1===================')

values = [1, 2, 3, 4, 5, 6]
probabilities = [1 / 6] * 6

average = sum([x * p for x, p in zip(values, probabilities)])
variance = sum([(x - average) ** 2 * p for x, p in zip(values, probabilities)])
std_dev = variance ** 0.5
skewness = sum([(x - average) ** 3 * p for x, p in zip(values, probabilities)]) / std_dev ** 3
kurtosis = sum([(x - average) ** 4 * p for x, p in zip(values, probabilities)]) / std_dev ** 4 - 3

print(f'Średnia: {average}')
print(f'Wariancja: {variance}')
print(f'Odchylenie standardowe: {std_dev}')
print(f'Skosnosc: {skewness}')
print(f'Kurtoza: {kurtosis}')

# Zadanie 2
print()
print('===================Zadanie 2===================')

n = 100

p_bernoulli = 0.5

n_binomial = 10
p_binomial = 0.5

lambda_poisson = 3

samples_bernoulli = np.random.binomial(1, p_bernoulli, n)
samples_binomial = np.random.binomial(n_binomial, p_binomial, n)
samples_poisson = np.random.poisson(lambda_poisson, n)

print(f'Rozkład Bernoulliego: {samples_bernoulli}')
print(f'Rozkład Dwumianowy: {samples_binomial}')
print(f'Rozkład Poissona: {samples_poisson}')

# Zadanie 3
print()
print('===================Zadanie 3===================')

bernoulli_average = np.mean(samples_bernoulli)
bernoulli_variance = np.var(samples_bernoulli)
bernoulli_skewness = stats.skew(samples_bernoulli)
bernoulli_kurtosis = stats.kurtosis(samples_bernoulli)

binomial_average = np.mean(samples_binomial)
binomial_variance = np.var(samples_binomial)
binomial_skewness = stats.skew(samples_binomial)
binomial_kurtosis = stats.kurtosis(samples_binomial)

poisson_average = np.mean(samples_poisson)
poisson_variance = np.var(samples_poisson)
poisson_skewness = stats.skew(samples_poisson)
poisson_kurtosis = stats.kurtosis(samples_poisson)

print('Rozkład Bernoulliego:')
print(f'Średnia: {bernoulli_average}')
print(f'Wariancja: {bernoulli_variance}')
print(f'Skośność: {bernoulli_skewness}')
print(f'Kurtoza: {bernoulli_kurtosis}')

print()

print('Rozkład Dwumianowy:')
print(f'Średnia: {binomial_average}')
print(f'Wariancja: {binomial_variance}')
print(f'Skośność: {binomial_skewness}')
print(f'Kurtoza: {binomial_kurtosis}')

print()

print('Rozkład Poissona:')
print(f'Średnia: {poisson_average}')
print(f'Wariancja: {poisson_variance}')
print(f'Skośność: {poisson_skewness}')
print(f'Kurtoza: {poisson_kurtosis}')

# Zadanie 4
plt.figure(figsize=(15, 5))

plt.subplot(1, 3, 1)
plt.hist(samples_bernoulli, bins=[-0.5, 0.5, 1.5], rwidth=0.8, color='blue', alpha=0.7)
plt.title('Rozkład Bernoulliego')
plt.xticks([0, 1])
plt.xlabel('Wartość')
plt.ylabel('Częstość')

plt.subplot(1, 3, 2)
plt.hist(samples_binomial, bins=range(n_binomial + 2), rwidth=0.8, color='green', alpha=0.7)
plt.title('Rozkład Dwumianowy')
plt.xlabel('Liczba sukcesów')
plt.ylabel('Częstość')

plt.subplot(1, 3, 3)
max_poisson = max(samples_poisson) + 1
plt.hist(samples_poisson, bins=range(max_poisson + 1), rwidth=0.8, color='red', alpha=0.7)
plt.title('Rozkład Poissona')
plt.xlabel('Liczba zdarzeń')
plt.ylabel('Częstość')

plt.tight_layout()
plt.show()

# Zadanie 5
print()
print('===================Zadanie 5===================')

n = 20
p = 0.4

binomial_probabilities = [stats.binom.pmf(k, n, p) for k in range(n + 1)]
probabilities_sum = sum(binomial_probabilities)

print(f'Prawdopodobieństwa Dwumianowe: {binomial_probabilities}')
print(f'Suma Prawdopodobieństw: {probabilities_sum}')

# Zadanie 6
print()
print('===================Zadanie 6===================')

np.random.seed(0)

samples_normal_100 = np.random.normal(0, 2, 100)
average_100 = np.mean(samples_normal_100)
variance_100 = np.var(samples_normal_100)
std_dev_100 = np.std(samples_normal_100)
skewness_100 = stats.skew(samples_normal_100)
kurtosis_100 = stats.kurtosis(samples_normal_100)

samples_normal_1000000 = np.random.normal(0, 2, 1000000)
average_1000000 = np.mean(samples_normal_1000000)
variance_1000000 = np.var(samples_normal_1000000)
std_dev_1000000 = np.std(samples_normal_1000000)
skewness_1000000 = stats.skew(samples_normal_1000000)
kurtosis_1000000 = stats.kurtosis(samples_normal_1000000)

print('Statystyki dla 100 danych:')
print(f'Średnia: {average_100}')
print(f'Wariancja: {variance_100}')
print(f'Odchylenie standardowe: {std_dev_100}')
print(f'Skosnosc: {skewness_100}')
print(f'Kurtoza: {kurtosis_100}')

print()

print('Statystyki dla 1000000 danych:')
print(f'Średnia: {average_1000000}')
print(f'Wariancja: {variance_1000000}')
print(f'Odchylenie standardowe: {std_dev_1000000}')
print(f'Skosnosc: {skewness_1000000}')
print(f'Kurtoza: {kurtosis_1000000}')

# Wraz ze wzrostem liczby danych, statystyki stają się bliższe wartościom teoretycznym.
# Średnia i odchylenie standardowe są bliższe oczekiwanych wartości,
# a skośność i kurtoza zbliżają się do 0.


# Zadanie 7
data_normal_1 = np.random.normal(1, 2, 1000)
data_normal_2 = np.random.normal(0, 1, 1000)
data_normal_3 = np.random.normal(-1, .5, 1000)

plt.figure(figsize=(10, 6))

plt.hist(data_normal_1, bins=30, alpha=0.5, color='blue', density=True, label='Średnia=1, Odchylenie=2')
plt.hist(data_normal_2, bins=30, alpha=0.5, color='green', density=True, label='Rozkład Standardowy')
sns.kdeplot(data_normal_3, color='red', label='Średnia=-1, Odchylenie=0.5')

plt.title('Histogramy i wykres gęstości dla różnych rozkładów normalnych')
plt.xlabel('Wartość')
plt.ylabel('Gęstość prawdopodobieństwa')
plt.legend()

plt.show()
