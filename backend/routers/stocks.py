from fastapi import APIRouter 
from fastapi import  HTTPException

from services.stock_data import get_stock_data
from services.price_prediction import price_prediction
from models.stock_symbol import StockSymbol

from services.stock_data import get_stock_history_data
from services.stock_data import search_stocks


router = APIRouter()

# API Endpoint: Hisse bilgisi
@router.get("/{symbol}")
def read_stock(symbol: str):
    stock_data = get_stock_data(symbol)
    if not stock_data:
        raise HTTPException(status_code=404, detail="Hisse bulunamadı.")
    return stock_data


# API Endpoint: Hisse senedi fiyat tahmini
@router.post("/predict")
def predict_future(request: StockSymbol):
    prediction = price_prediction(request.symbol)
    if not prediction:
        raise HTTPException(status_code=404, detail="Hisse bulunamadı.")
    return prediction

# API Endpoint: Belirli periyotlara göre hisse fiyat verisi
@router.get("/{symbol}/history/{period}")
def get_stock_history(symbol: str, period: str):
    valid_periods = [ "5d", "1mo", "3mo", "6mo", "1y", "2y", "5y", "10y", "ytd", "max"]
    
    if period not in valid_periods:
        raise HTTPException(
            status_code=400, 
            detail="Geçersiz periyot. Geçerli değerler: ['5d', '1mo', '3mo', '6mo', '1y', '2y', '5y', '10y', 'ytd', 'max']"
        )
    
    try:
        
        stock_data = get_stock_history_data(symbol, period)
        if not stock_data:
            raise HTTPException(status_code=404, detail="Hisse verisi bulunamadı.")
        return stock_data
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
    

# API Endpoint: Hisse senedi arama
@router.get("/search/{query}")
def search_stocks_endpoint(query: str):
    try:
        results = search_stocks(query)
        if not results:
            raise HTTPException(status_code=404, detail="Sonuç bulunamadı.")
        return results
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))



