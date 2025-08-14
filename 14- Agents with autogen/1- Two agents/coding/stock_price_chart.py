# filename: stock_price_chart.py
import pandas as pd
import matplotlib.pyplot as plt
import requests
import os
from dotenv import load_dotenv

load_dotenv()
ALPHA_VANTAGE_API_KEY=os.getenv("ALPHA_VANTAGE_API_KEY")

# Function to fetch stock price data from Alpha Vantage API
def fetch_stock_data(symbol):
    # Replace 'YOUR_API_KEY' with your actual API Key
    api_key = ALPHA_VANTAGE_API_KEY
    url = f'https://www.alphavantage.co/query?function=TIME_SERIES_DAILY&symbol={symbol}&apikey={api_key}'
    response = requests.get(url)
    data = response.json()['Time Series (Daily)']
    df = pd.DataFrame(data).T
    df.index = pd.to_datetime(df.index)
    df['close'] = pd.to_numeric(df['4. close'])
    return df['close']

# Fetch stock price data for NVDA and TESLA
nvda_stock_data = fetch_stock_data('NVDA')
tesla_stock_data = fetch_stock_data('TSLA')

# Plot the stock price change
plt.figure(figsize=(14, 7))
plt.plot(nvda_stock_data.index, nvda_stock_data.values, label='NVDA')
plt.plot(tesla_stock_data.index, tesla_stock_data.values, label='TESLA')
plt.title('NVDA vs TESLA Stock Price Change')
plt.xlabel('Date')
plt.ylabel('Stock Price (USD)')
plt.legend()
plt.grid(True)
plt.show()