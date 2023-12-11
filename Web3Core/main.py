# main.py
from fastapi import FastAPI, Request, HTTPException
from fastapi.templating import Jinja2Templates
from fastapi.staticfiles import StaticFiles
from web3 import Web3

app = FastAPI()
templates = Jinja2Templates(directory="templates")

# Initialize Web3 (connect to Ethereum node)
w3 = Web3(Web3.HTTPProvider('https://mainnet.infura.io/v3/YOUR_INFURA_PROJECT_ID'))

app.mount("/static", StaticFiles(directory="static"), name="static")

@app.get("/")
async def get_home(request: Request):
    return templates.TemplateResponse("home.html", {"request": request})

@app.post("/login")
async def login(request: Request, username: str = Form(...), password: str = Form(...)):
    # Here you should verify username and password
    # This is just a placeholder logic
    if username == "admin" and password == "secret":
        return templates.TemplateResponse("dashboard.html", {"request": request, "username": username})
    return templates.TemplateResponse("home.html", {"request": request, "error": "Invalid credentials"})


@app.post("/auth/web3auth")
async def web3auth_login(token: str):
    # Here, you should verify the token using Web3Auth's verification process
    # For simplicity, let's assume the token contains the user's wallet address
    user_wallet_address = token  # In real scenarios, decode and verify the token

    # Check if the address is valid
    if not w3.isAddress(user_wallet_address):
        raise HTTPException(status_code=400, detail="Invalid wallet address")

    # Add logic to handle user session or other processing
    # ...

    return {"message": "User authenticated", "wallet": user_wallet_address}

@app.get("/wallet/balance/{wallet_address}")
async def get_wallet_balance(wallet_address: str):
    # Validate the wallet address
    if not w3.isAddress(wallet_address):
        raise HTTPException(status_code=400, detail="Invalid wallet address")

    # Get balance
    balance = w3.eth.getBalance(wallet_address)
    # Convert balance to Ether
    balance_in_ether = w3.fromWei(balance, 'ether')

    return {"wallet": wallet_address, "balance": balance_in_ether}