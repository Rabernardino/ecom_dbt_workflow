

CREATE TABLE raw_sellers (
    seller_id VARCHAR(32) NOT NULL PRIMARY KEY,
    seller_zip_code_prefix INTEGER NOT NULL,
    seller_city VARCHAR(100) NOT NULL,
    seller_state CHAR(2) NOT NULL
);