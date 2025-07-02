import os
from pymongo.mongo_client import MongoClient
from pymongo.server_api import ServerApi
from dotenv import load_dotenv

load_dotenv()
uri = os.getenv("MONGO_URI")
cli = MongoClient(uri, server_api=ServerApi('1'))
db = cli["med_data"]
