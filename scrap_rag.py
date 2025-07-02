import os
import requests
from bs4 import BeautifulSoup
from pymongo.mongo_client import MongoClient
from pymongo.server_api import ServerApi
from dotenv import load_dotenv
import csv

load_dotenv()
uri = os.getenv("MONGO_URI")
cli = MongoClient(uri, server_api=ServerApi('1'))
db = cli["med_data"]

def scrp(url, sel="p"):
    r = requests.get(url)
    s = BeautifulSoup(r.text, "html.parser")
    ps = s.select(sel)
    for x in ps:
        t = x.get_text(strip=True)
        if t and len(t) > 40:
            db.rag.insert_one({"txt": t, "md": {"src": url}})

with open("gov_urls.csv", "r") as f:
    rdr = csv.reader(f)
    for row in rdr:
        if row:
            url = row[0]
            try:
                scrp(url)
                print(f"Scraped: {url}")
            except Exception as e:
                print(f"Failed: {url} | {e}")
