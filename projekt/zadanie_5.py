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
    'linear': {
        'name': 'Regresja liniowa',
        'model': LinearRegression(),
        'color': 'red',
        'forecast_value': None,
    },
    'polynomial': {
        'name': 'Regresja wielomianowa',
        'model': make_pipeline(PolynomialFeatures(2), LinearRegression()),
        'color': 'black',
        'forecast_value': None,
    },
}

for code in codes:
    code_df = pd.read_csv(f'binance_data/{code}.csv')
    code_df['dateTime'] = pd.to_datetime(code_df['dateTime'])
    X = code_df['dateTime'].apply(lambda x: x.timestamp()).values.reshape(-1, 1)
    y = code_df[forecast_column].values
    future_datetime = pd.to_datetime(future_date)

    fig, ax = plt.subplots(figsize=(20, 20))
    ax.scatter(
        code_df['dateTime'],
        y,
        label='Dane rzeczywiste',
    )

    new_code_df = pd.read_csv(f'binance_data_new/{code}.csv')
    new_code_df['dateTime'] = pd.to_datetime(new_code_df['dateTime'])

    real_value = new_code_df[new_code_df['dateTime'] == future_date][forecast_column].values[0]
    new_code_df.drop(new_code_df[new_code_df['dateTime'] == future_date].index, inplace=True)

    ax.scatter(
        new_code_df['dateTime'],
        new_code_df[forecast_column].values,
        label='Nowe dane rzeczywiste',
        color='green',
    )

    ax.scatter(
        future_datetime,
        real_value,
        label='Faktyczna wartość',
        color='green',
        marker='x',
    )

    for regression, regression_model in regressions_models.items():
        model = regression_model['model']
        color = regression_model['color']
        model.fit(X, y)
        y_pred = model.predict(X)
        forecast_value = model.predict(np.array([[future_datetime.timestamp()]]))
        regression_model['forecast_value'] = forecast_value[0]

        ax.scatter(
            future_datetime,
            forecast_value,
            label=f'{regression_model["name"]} - przewidziana wartość',
            color=color,
            marker='x',
        )
        ax.plot(
            code_df['dateTime'],
            y_pred,
            color=color,
            label=regression_model['name'],
        )

    ax.xaxis.set_major_formatter(DateFormatter("%Y-%m-%d %H:%M:%S"))
    plt.xticks(rotation=45)
    plt.xlabel('Data')
    plt.ylabel(forecast_column)
    plt.legend(fontsize=20)
    fig.text(
        0.5,
        -0.01,
        f'Przewidziana wartość według regresji liniowej: {regressions_models["linear"]["forecast_value"]}\n'
        f'Przewidziana wartość według regresji wielomianowej: {regressions_models["polynomial"]["forecast_value"]}\n'
        f'Faktyczna wartość: {real_value}\n',
        ha='center',
        fontsize=15,
        color='blue',
    )
    plt.title(f'{code} - Regresja liniowa i wielomianowa dla kolumny "{forecast_column}"', fontsize=20)
    plt.show()
