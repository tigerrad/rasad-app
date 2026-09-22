from fastapi import FastAPI, HTTPException
from typing import Optional

app = FastAPI(title="Rasad API", version="0.1.0")

MOCK_PRODUCTS = [
    {"id": 1, "name": "لپ تاپ ایسر Predator", "price": 460000000, "shop": "سما رایانه"},
    {"id": 2, "name": "لپ تاپ ایسر Predator", "price": 485000000, "shop": "دیجی‌کالا"},
    {"id": 3, "name": "گوشی سامسونگ S24", "price": 52000000, "shop": "موبایل‌سنتر"},
]

@app.get("/")
def root():
    return {"message": "Rasad API is running"}

@app.get("/api/products")
def search_products(q: Optional[str] = None):
    if q:
        results = [p for p in MOCK_PRODUCTS if q in p["name"]]
    else:
        results = MOCK_PRODUCTS
    return {"products": results, "count": len(results)}

@app.get("/api/products/{product_id}/best-price")
def best_price(product_id: int):
    product = next((p for p in MOCK_PRODUCTS if p["id"] == product_id), None)
    if not product:
        raise HTTPException(status_code=404, detail="محصول پیدا نشد")
    same_name = [p for p in MOCK_PRODUCTS if p["name"] == product["name"]]
    cheapest = min(same_name, key=lambda x: x["price"])
    return {"product": product["name"], "best_price": cheapest["price"], "shop": cheapest["shop"]}