from fastapi import APIRouter 
from fastapi import  HTTPException

from services.stock_data import get_stock_data
from services.price_prediction import price_prediction
from models.stock_symbol import StockSymbol

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

