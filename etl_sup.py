


import os
import pandas as pd

from dotenv import load_dotenv
from sqlalchemy import create_engine
from urllib import parse


load_dotenv()

db_user = os.getenv('DB_USER')
db_pass = os.getenv('DB_PASS')
db_host = os.getenv('DB_HOST')
db_port = os.getenv('DB_PORT')
db_database = os.getenv('DB_NAME')


safe_pass = parse.quote_plus(db_pass)


db_sup = f'postgresql://{db_user}:{safe_pass}@{db_host}:{db_port}/{db_database}'




