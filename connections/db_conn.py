

import os
import logging

from dotenv import load_dotenv
from sqlalchemy import create_engine
from urllib import parse


load_dotenv()

logger = logging.getLogger(__name__)

class PostgresConn:

    def __init__(self):

        self.host = os.getenv('DB_HOST')
        self.port = os.getenv('DB_PORT')
        self.user = os.getenv('DB_USER')
        self.password = os.getenv('DB_PASS')
        self.db = os.getenv('DB_NAME')

        safe_pass = parse.quote_plus(self.password)

        # self.url = f"postgresql+psycopg2://{self.user}:{self.password}@{self.host}:{self.port}/{self.db}"
        self.url = f'postgresql://{self.user}:{safe_pass}@{self.host}:{self.port}/{self.db}'

        
        self._create_engine()


    def _create_engine(self):

        try:
            self.engine = create_engine(self.url)

        except Exception as e:
            logger.info(f'Falha na conexao com o banco')
            raise e


    def insert_data(self, dataframe, table_name, schema):

        if self.engine is None:
            logger.error(f'Falha na conexao com o banco')
            raise

        try:
            with self.engine.begin() as conn:
                dataframe.to_sql(
                    name=table_name,
                    con=conn,
                    schema=schema,
                    if_exists='replace',
                    index=False,
                    chunksize=10000
                )


        except Exception as e:
            logger.error(f'Falha durante o insert dos dados no banco')
            raise
    