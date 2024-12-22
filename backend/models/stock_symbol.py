from pydantic import BaseModel

# Veri modeli
class StockSymbol(BaseModel):
    symbol: str  # Hisse senedi sembolü