from fastapi import FastAPI, Request, File, UploadFile
from fastapi.middleware.cors import CORSMiddleware
from db import db
import os, requests
from dotenv import load_dotenv

load_dotenv()
GEM_URL = "https://generativelanguage.googleapis.com/v1/models/gemini-1.5-flash:generateContent"
GEM_KEY = os.getenv("GEMINI_API_KEY")

app = FastAPI()
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.get("/")
def root():
    return {"msg": "mHealth Chatbot API is live"}

@app.get("/test-mongo")
def tst_m():
    c = db.list_collection_names()
    return {"c": c}

@app.post("/chat/send")
async def cht_snd(r: Request):
    d = await r.json()
    db.chats.insert_one({"u": d["user"], "m": d["message"]})
    return {"s": "ok"}

@app.get("/chat/history/{u}")
def cht_hist(u: str):
    m = list(db.chats.find({"u": u}, {"_id": 0}))
    return {"h": m}

@app.post("/insrt/{c}")
async def insrt(c: str, r: Request):
    d = await r.json()
    db[c].insert_one(d)
    return {"s": "ok"}

@app.get("/fch/{c}")
def fch(c: str):
    d = list(db[c].find({}, {"_id": 0}))
    return {"d": d}

@app.post("/img/up")
async def img_up(f: UploadFile = File(...)):
    b = await f.read()
    db.imgs.insert_one({"fn": f.filename, "ct": b})
    return {"s": "ok"}

@app.post("/rag/add")
async def rag_add(r: Request):
    d = await r.json()
    db.rag.insert_one({"txt": d["txt"], "md": d.get("md", {})})
    return {"s": "ok"}

@app.get("/rag/fch")
def rag_fch():
    d = list(db.rag.find({}, {"_id": 0}))
    return {"d": d}

@app.post("/fbk/add")
async def fbk_add(r: Request):
    d = await r.json()
    db.fbk.insert_one({"u": d["u"], "m": d["m"], "f": d.get("f", "")})
    return {"s": "ok"}

@app.get("/fbk/all")
def fbk_all():
    d = list(db.fbk.find({}, {"_id": 0}))
    return {"d": d}

@app.post("/chat/gemini")
async def cht_gem(r: Request):
    d = await r.json()
    q = d.get("q", "")
    history = d.get("history", [])
    messages = []
    for msg in history:
        if not isinstance(msg, dict):
            continue
        role = "user" if msg.get("u") == "me" else "model"
        text = msg.get("m")
        if text:
            messages.append({"role": role, "parts": [{"text": str(text)}]})
    if q:
        messages.append({"role": "user", "parts": [{"text": str(q)}]})
    body = {"contents": messages}
    prm = {"key": GEM_KEY}
    res = requests.post(GEM_URL, params=prm, json=body)
    try:
        a = res.json()["candidates"][0]["content"]["parts"][0]["text"]
    except Exception:
        a = res.text
    return {"a": a}


@app.post("/suggest-url")
async def suggest_url(r: Request):
    d = await r.json()
    u = d["url"]
    db.suggested_urls.insert_one({"url": u})
    return {"s": "ok"}
