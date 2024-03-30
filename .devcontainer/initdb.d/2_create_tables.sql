USE stock_data;

CREATE TABLE stock_data (
    id INT AUTO_INCREMENT PRIMARY KEY,
    symbol VARCHAR(16) NOT NULL,
    ticker_date DATE NOT NULL,
    price_open DECIMAL(8, 2) NULL,
    price_high DECIMAL(8, 2) NULL,
    price_low DECIMAL(8, 2) NULL,
    price_close DECIMAL(8, 2) NULL,
    volume INT NULL
);
