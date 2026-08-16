

import os
import pandas as pd

from config import DATA_DIR
from connections.db_conn import PostgresConn

raw_customers = pd.read_csv(os.path.join(DATA_DIR, 'olist_customers_dataset.csv'))
raw_geo = pd.read_csv(os.path.join(DATA_DIR, 'olist_geolocation_dataset.csv'))
raw_order_items = pd.read_csv(os.path.join(DATA_DIR, 'olist_order_items_dataset.csv'))
raw_order_payments = pd.read_csv(os.path.join(DATA_DIR, 'olist_order_payments_dataset.csv'))
raw_order_reviews = pd.read_csv(os.path.join(DATA_DIR, 'olist_order_reviews_dataset.csv'))
raw_orders = pd.read_csv(os.path.join(DATA_DIR, 'olist_orders_dataset.csv'))
raw_products = pd.read_csv(os.path.join(DATA_DIR, 'olist_products_dataset.csv'))
raw_sellers = pd.read_csv(os.path.join(DATA_DIR, 'olist_sellers_dataset.csv'))


dfs = {
'raw_customers': raw_customers,
'raw_geo': raw_geo,
'raw_order_items': raw_order_items,
'raw_order_payments': raw_order_payments,
'raw_order_reviews': raw_order_reviews,
'raw_orders': raw_orders,
'raw_products': raw_products,
'raw_sellers': raw_sellers
}


# Mapping date
change_year = {
    '2016':'2024',
    '2017':'2025',
    '2018':'2026'
}

for col in ['order_purchase_timestamp', 'order_approved_at', 'order_delivered_carrier_date', 'order_delivered_customer_date', 'order_estimated_delivery_date']:
    raw_orders[col] = pd.to_datetime(raw_orders[col].astype(str).replace(change_year, regex=True))

raw_order_items['shipping_limit_date'] = pd.to_datetime(raw_order_items['shipping_limit_date'].astype(str).replace(change_year, regex=True))

for col in ['review_creation_date', 'review_answer_timestamp']:
    raw_order_reviews[col] = pd.to_datetime(raw_order_reviews[col].astype(str).replace(change_year, regex=True))

db_conn = PostgresConn()

for key, value in dfs.items():
    db_conn.insert_data(
        value,
        key,
        schema='raw'  
    )



