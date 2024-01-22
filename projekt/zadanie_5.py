import numpy as np
import pandas as pd
from matplotlib import pyplot as plt
from matplotlib.dates import DateFormatter
from sklearn.linear_model import LinearRegression
from sklearn.pipeline import make_pipeline
from sklearn.preprocessing import PolynomialFeatures

codes = [
    'BTCUSDT',
    'ETHUSDT',
    'BNBUSDT',
    'DOGEUSDT',
    'CAKEUSDT',
]

forecast_column = 'open'
future_date = '2024-01-23 12:00:00'

regressions_models = {
    'Regresja liniowa': LinearRegression(),
    'Regresja wielomianowa': make_pipeline(PolynomialFeatures(2), LinearRegression()),
}

for code in codes:
    code_df = pd.read_csv(f'binance_data/{code}.csv')
    code_df['dateTime'] = pd.to_datetime(code_df['dateTime'])
    X = code_df['dateTime'].apply(lambda x: x.timestamp()).values.reshape(-1, 1)
    y = code_df[forecast_column].values
    future_datetime = pd.to_datetime(future_date)

    fig, ax = plt.subplots(1, 2, figsize=(50, 30), )
    for index, (regression_name, regression_model) in enumerate(regressions_models.items()):
        model = regression_model
        model.fit(X, y)
        y_pred = model.predict(X)
        forecast_value = model.predict(np.array([[future_datetime.timestamp()]]))

        ax[index].scatter(code_df['dateTime'], y, label='Dane rzeczywiste')
        ax[index].scatter(future_datetime, forecast_value, label=f'Przewidziana wartość ({forecast_value[0]})', color='red',marker='*')
        ax[index].plot(code_df['dateTime'], y_pred, color='red', label=regression_name)
        ax[index].xaxis.set_major_formatter(DateFormatter("%Y-%m-%d %H:%M:%S"))
        ax[index].tick_params(axis='x', rotation=45)
        ax[index].set_xlabel('Data')
        ax[index].set_ylabel(forecast_column)
        ax[index].legend(fontsize=30)
        ax[index].set_title(f'{code} - {regression_name} dla kolumny "{forecast_column}"', fontsize='50')

    plt.show()
