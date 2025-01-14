from fastapi import  HTTPException
import pandas as pd
import numpy as np
import yfinance as yf
import datetime
from sklearn.preprocessing import MinMaxScaler
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import LSTM, Dense
from tensorflow.keras.optimizers import Adam

# Yardımcı fonksiyonlar
def get_stock_price_data(symbol):
    stock = yf.Ticker(symbol)
    historical_data = stock.history(period="2y")
    historical_data.reset_index(inplace=True)
    return historical_data

def str_to_datetime(s):
    split = str(s).split('-')
    year, month, day = int(split[0]), int(split[1]), int(split[2])
    return datetime.datetime(year=year, month=month, day=day)

def df_to_windowed_df(dataframe, first_date_str, last_date_str, n=3):
    first_date = str_to_datetime(first_date_str)
    last_date = str_to_datetime(last_date_str)
    target_date = first_date + datetime.timedelta(days=n+3)

    dates = []
    X, Y = [], []
    last_time = False

    while True:
        df_subset = dataframe.loc[:target_date].tail(n+1)
        if len(df_subset) != n+1:
            break

        values = df_subset['Close'].to_numpy()
        x, y = values[:-1], values[-1]
        dates.append(target_date)
        X.append(x)
        Y.append(y)

        next_week = dataframe.loc[target_date:target_date+datetime.timedelta(days=7)]
        if len(next_week) < 2:
            break

        next_datetime_str = str(next_week.head(2).tail(1).index.values[0])
        next_date_str = next_datetime_str.split('T')[0]
        year, month, day = map(int, next_date_str.split('-'))
        next_date = datetime.datetime(year=year, month=month, day=day)

        if last_time:
            break

        target_date = next_date
        if target_date == last_date:
            last_time = True

    ret_df = pd.DataFrame({})
    ret_df['Target Date'] = dates
    X = np.array(X)
    for i in range(0, n):
        ret_df[f'Target-{n-i}'] = X[:, i]
    ret_df['Target'] = Y

    return ret_df

def windowed_df_to_date_X_y(windowed_dataframe):
    df_as_np = windowed_dataframe.to_numpy()
    dates = df_as_np[:, 0]
    middle_matrix = df_as_np[:, 1:-1]
    X = middle_matrix.reshape((len(dates), middle_matrix.shape[1], 1))
    Y = df_as_np[:, -1]
    return dates, X.astype(np.float32), Y.astype(np.float32)

# Hisse senedi fiyat tahmini
def price_prediction(symbol: str):
    try:
        # 1. Hisse senedi verisini çek
        historical_data = get_stock_price_data(symbol)
        
        # 2. Veriyi işleme
        df = historical_data[['Date', 'Close']].copy()
        df['Date'] = pd.to_datetime(df['Date']).dt.date
        df['Date'] = df['Date'].apply(str_to_datetime)
        df.index = df.pop('Date')
        df['Close'] = np.log(df['Close'])

        scaler = MinMaxScaler(feature_range=(0, 1))
        scaled_data = scaler.fit_transform(df[['Close']].values)
        df['Close'] = scaled_data

        # 3. Windowed veri oluşturma
        min_date = df.index.min().strftime("%Y-%m-%d")
        max_date = df.index.max().strftime("%Y-%m-%d")
        windowed_df = df_to_windowed_df(df, min_date, max_date, n=3)

        dates, X, y = windowed_df_to_date_X_y(windowed_df)

        q_70 = int(len(dates) * .7)
        q_85 = int(len(dates) * .85)

        X_train, y_train = X[:q_70], y[:q_70]
        X_test = X[q_85:]

        # 4. LSTM modeli oluşturma ve eğitim
        model = Sequential([
            LSTM(64, input_shape=(3, 1)),
            Dense(32, activation='relu'),
            Dense(32, activation='relu'),
            Dense(1)
        ])
        model.compile(loss='mse', optimizer=Adam(learning_rate=0.001))
        model.fit(X_train, y_train, epochs=20, verbose=0)

        # 5. Gelecek tahmini
        future_predictions = []
        last_window = X_test[-1]  # Son 3 günlük veri
        for i in range(30):
            prediction = model.predict(last_window.reshape(1, 3, 1))
            future_predictions.append(prediction[0][0])
            last_window = np.append(last_window[1:], prediction)
            last_window = last_window.reshape(3, 1)

        future_predictions = np.array(future_predictions).reshape(-1, 1)
        future_predictions = scaler.inverse_transform(future_predictions)
        future_predictions = np.exp(future_predictions)

        # Gelecek tarihleri oluşturma
        last_date = dates[-1]
        future_dates = [last_date + datetime.timedelta(days=i) for i in range(1, 31)]

        # 6. Gerçek ve tahmini verileri birleştirme
        future_data = pd.DataFrame({
            "Date": [date.strftime("%Y-%m-%d") for date in future_dates],
            "Close": future_predictions.flatten()
        })

        # 7. Sonuçları döndürme
        return future_data.to_dict(orient="records")

    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))