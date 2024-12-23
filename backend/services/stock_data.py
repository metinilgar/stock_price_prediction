import yfinance as yf
import requests
from fastapi import HTTPException

# Hisse bilgilerini çeken yardımcı fonksiyon
def get_stock_data(symbol: str):
    try:
        ticker = yf.Ticker(symbol)
        info = ticker.info

        # Bilgileri toparla
        stock_data = {
            "company_name": info.get("longName", "Bilinmiyor"),
            "sector": info.get("sector", "Bilinmiyor"),
            "industry": info.get("industry", "Bilinmiyor"),
            "current_price": info.get("currentPrice", "Bilinmiyor"),
            "52_week_high": info.get("fiftyTwoWeekHigh", "Bilinmiyor"),
            "52_week_low": info.get("fiftyTwoWeekLow", "Bilinmiyor"),
            "market_cap": info.get("marketCap", "Bilinmiyor"),
            "pe_ratio": info.get("trailingPE", "Bilinmiyor"),
            "dividend_yield": info.get("dividendYield", "Bilinmiyor"),
            "beta": info.get("beta", "Bilinmiyor"),
        }
        return stock_data
    except Exception as e:
        raise HTTPException(status_code=400, detail=str(e))
    

# Yardımcı fonksiyonlar
def get_stock_history_data(symbol, period):
    stock = yf.Ticker(symbol)
    historical_data = stock.history(period=period)
    historical_data.reset_index(inplace=True)

    # Veriyi JSON formatına dönüştür
    historical_data['Date'] = historical_data['Date'].astype(str)
    json_data = historical_data[['Date', 'Open', 'High', 'Low', 'Close', 'Volume']].to_dict(orient='records')
    
    return json_data



def search_stocks(query: str):
    try:
        # Yahoo Finance API'sini kullanarak arama yap
        url = f"https://query2.finance.yahoo.com/v1/finance/search?q={query}"
        headers = {'User-Agent': 'Mozilla/5.0'}
        
        response = requests.get(url, headers=headers)
        data = response.json()
        
        # Sonuçları işle
        results = []
        if 'quotes' in data:
            for quote in data['quotes']:
                if 'symbol' in quote and 'shortname' in quote:
                    results.append({
                        'symbol': quote['symbol'],
                        'name': quote['shortname']
                    })
                    
        # En fazla 10 sonuç döndür            
        return results[:10]
        
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
