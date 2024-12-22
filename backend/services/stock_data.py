import yfinance as yf
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