import asyncio
import math
import random
from fastapi import FastAPI, WebSocket
from fastapi.staticfiles import StaticFiles
from fastapi.responses import HTMLResponse

app = FastAPI()
app.mount("/static", StaticFiles(directory="static"), name="static")

# Konfiguration av aktier
stocks_config = {
    "AAPL": {"s0": 150.0, "sigma": 0.01, "mean_delay": 1.0},
    "GOOG": {"s0": 2800.0, "sigma": 0.015, "mean_delay": 2.0},
    "TSLA": {"s0": 900.0, "sigma": 0.02, "mean_delay": 1.5}
}

# Normalfördelad slumpgenerator
def gauss_random():
    u1 = random.random()
    u2 = random.random()
    z0 = math.sqrt(-2 * math.log(u1)) * math.cos(2 * math.pi * u2)
    return z0

@app.get("/")
async def get():
    with open("static/index.html") as f:
        return HTMLResponse(f.read())

# Kör en separat loop för varje aktie
async def stream_stock(websocket: WebSocket, name: str, config: dict):
    log_sum = 0.0
    try:
        while True:
            v = gauss_random()
            log_sum += config["sigma"] * v
            price = config["s0"] * math.exp(log_sum)
            await websocket.send_json({"stock": name, "price": round(price, 2)})

            delay = random.expovariate(1 / config["mean_delay"])
            await asyncio.sleep(delay)
    except Exception as e:
        print(f"Stopped streaming {name}: {e}")

@app.websocket("/ws")
async def websocket_endpoint(websocket: WebSocket):
    await websocket.accept()

    tasks = []
    for name, config in stocks_config.items():
        task = asyncio.create_task(stream_stock(websocket, name, config))
        tasks.append(task)

    try:
        await asyncio.gather(*tasks)
    except Exception as e:
        print("WebSocket closed:", e)

