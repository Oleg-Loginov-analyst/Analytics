Требуется написать bash-скрипт, который будет совершать следующие действия:
1. Пересоздавать таблицу в Сlickhouse (листинг DDL будет описан ниже) используя clickhouse-client;
2. Выгрузить csv-файл;
3. Выполнять insert содержимого csv файла в созданную таблицу в Сlickhouse (если в Вашем решении для этого потребуются некоторые преобразования исходных данных в файле, то эти преобразования должны быть выполнены тоже с помощью bash-скрипта).

DDL-запрос для создания таблицы:
create table events_test (
user_id String
,product_identifier Nullable(String)
,start_time DateTime
,end_time Nullable(DateTime)
,price_in_usd Nullable(Float32)
)
ENGINE = ReplacingMergeTree() partition by(toYYYYMM(start_time)) order by (start_time, user_id) settings index_granularity = 8192
