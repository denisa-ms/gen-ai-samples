# filename: plot_stock_price_change.py

import pandas as pd
import matplotlib.pyplot as plt
import yfinance as yf

def plot_stock_price_change(ticker_symbol_1, ticker_symbol_2):
    # Download stock data
    stock_data_1 = yf.download(ticker_symbol_1, start="2022-01-01", end="2022-12-31")
    stock_data_2 = yf.download(ticker_symbol_2, start="2022-01-01", end="2022-12-31")

    # Calculate percentage change
    stock_data_1['Pct Change'] = stock_data_1['Adj Close'].pct_change().fillna(0)
    stock_data_2['Pct Change'] = stock_data_2['Adj Close'].pct_change().fillna(0)

    # Create a DataFrame with percentage changes
    pct_change_df = pd.DataFrame({
        f'{ticker_symbol_1} Pct Change': stock_data_1['Pct Change'],
        f'{ticker_symbol_2} Pct Change': stock_data_2['Pct Change']
    })

    # Plot the data
    plt.figure(figsize=(14, 7))
    plt.plot(pct_change_df[f'{ticker_symbol_1} Pct Change'], label=ticker_symbol_1)
    plt.plot(pct_change_df[f'{ticker_symbol_2} Pct Change'], label=ticker_symbol_2)

    plt.title('Stock Price Percentage Change')
    plt.xlabel('Date')
    plt.ylabel('Percentage Change')
    plt.legend(loc="best")
    plt.grid()
    plt.show()

# Plot META and TSLA stock price changes
plot_stock_price_change("META", "TSLA")