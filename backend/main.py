from fastapi import FastAPI
from routers import stocks

# FastAPI uygulaması oluştur
app = FastAPI()

# Rotaları ekleme
app.include_router(stocks.router, prefix="/stock", tags=["Stocks"])

@app.get("/")
def root():
    return {"message": "FastAPI backend is running"}