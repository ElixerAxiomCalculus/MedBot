import os
from pymongo.mongo_client import MongoClient
from pymongo.server_api import ServerApi
from dotenv import load_dotenv

load_dotenv()
uri = os.getenv("MONGO_URI")
cli = MongoClient(uri, server_api=ServerApi('1'))
db = cli["med_data"]

def add_txt(p):
    with open(p, "r", encoding="utf8") as f:
        t = f.read()
        db.rag.insert_one({"txt": t})

def add_csv(p, col=0):
    import csv
    with open(p, "r", encoding="utf8") as f:
        rdr = csv.reader(f)
        for row in rdr:
            if row: db.rag.insert_one({"txt": row[col]})
