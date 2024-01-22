import csv
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
for code_id, code in codes.items():
    with open(f'binance_data/{code}.csv', 'r') as file:
        csv_reader = csv.reader(file)
        next(csv_reader)

        cursor = conn.cursor()
        query = f'INSERT INTO exchange_codes(code) VALUES(\'{code}\')'
        cursor.execute(query)
        for row in csv_reader:
            query = f'INSERT INTO ' \
                    f'exchange_history (code_id, dateTime, open, high, low, close, volume) ' \
                    f'VALUES({code_id}, TO_TIMESTAMP(\'{row[0]}\', \'yyyy-mm-dd hh24:mi:ss\'), ' \
                    f'{row[1]}, {row[2]}, {row[3]}, {row[4]}, {row[5]})'
            cursor.execute(query)

conn.commit()
cursor.close()
conn.close()
