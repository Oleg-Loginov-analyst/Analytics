# Предварительно разворачиваем локально ClickHouse 

#!/bin/bash

# Параметры подключения к ClickHouse
CH_HOST="localhost"
CH_PORT="9000"
CH_DATABASE="your_database_name"
CH_TABLE="events_test"

# Путь к csv-файлу
CSV_FILE="/путь-к-csv-файлу/file.csv"

# Листинг DDL для создания таблицы
DDL_QUERY="create table $CH_DATABASE.$CH_TABLE (
user_id String
,product_identifier Nullable(String)
,start_time DateTime
,end_time Nullable(DateTime)
,price_in_usd Nullable(Float32)
)
ENGINE = ReplacingMergeTree() partition by(toYYYYMM(start_time)) order by(start_time, user_id) settings index_granularity = 8192"

# Пересоздание таблицы в ClickHouse
clickhouse-client -h "$CH_HOST" --port "$CH_PORT" --query="$DDL_QUERY"

# Загрузка данных из csv-файла в таблицу
clickhouse-client -h "$CH_HOST" --port "$CH_PORT" --query="INSERT INTO $CH_DATABASE.$CH_TABLE FORMAT CSV" < "$CSV_FILE"
