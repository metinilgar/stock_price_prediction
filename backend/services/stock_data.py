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

def get_market_overview():
    try:
        # Takip edilecek sembollerin listesi
        symbols = {
            "BIST100": "XU100.IS",
            "USD/TRY": "USDTRY=X",
            "EUR/TRY": "EURTRY=X",
        }
        
        market_data = {}
        
        for market_name, symbol in symbols.items():
            ticker = yf.Ticker(symbol)
            current_data = ticker.history(period='1d')
            
            if not current_data.empty:
                # Numpy değerlerini native Python tiplerine dönüştür
                close_price = float(current_data['Close'].iloc[-1])
                open_price = float(current_data['Open'].iloc[0])
                high_price = float(current_data['High'].iloc[-1])
                low_price = float(current_data['Low'].iloc[-1])
                
                # Volume değeri varsa dönüştür
                volume = None
                if 'Volume' in current_data:
                    volume = int(current_data['Volume'].iloc[-1])
                
                # Değişim yüzdesini hesapla
                change_percentage = ((close_price - open_price) / open_price) * 100
                
                market_data[market_name] = {
                    "symbol": symbol,
                    "current_price": close_price,
                    "change": change_percentage,
                    "high": high_price,
                    "low": low_price,
                    "volume": volume
                }
            
        return market_data
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
