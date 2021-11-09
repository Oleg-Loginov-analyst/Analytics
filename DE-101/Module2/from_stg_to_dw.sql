CREATE SCHEMA dw;

--SHIPPING

--creating a table
DROP TABLE OF EXISTS dw.shipping_dim ;

CREATE TABLE dw.shipping_dim
(ship_id       serial NOT NULL,
shipping_mode varchar(14) NOT NULL,
CONSTRAINT PK_shipping_dim PRIMARY KEY (ship_id));

--deleting rows
TRUNCATE TABLE dw.shipping_dim;

--generating ship_id and inserting ship_mode from orders
INSERT INTO dw.shipping_dim 
SELECT
	100+ROW_NUMBER() OVER(), ship_mode
FROM
	(SELECT DISTINCT ship_mode FROM stg.orders ) a;

--checking
SELECT
	*
FROM
	dw.shipping_dim sd; 

--CUSTOMER

DROP TABLE OF EXISTS dw.customer_dim ;

CREATE TABLE dw.customer_dim
(cust_id serial NOT NULL,
customer_id VARCHAR(8) NOT NULL, --id can't be NULL
customer_name VARCHAR(22) NOT NULL,
CONSTRAINT PK_customer_dim PRIMARY KEY (cust_id));

--deleting rows
TRUNCATE TABLE dw.customer_dim;

--inserting
INSERT INTO dw.customer_dim 
SELECT
	100+ROW_NUMBER() OVER(), customer_id, customer_name
FROM
	(SELECT DISTINCT customer_id, customer_name FROM stg.orders) a;

--checking
SELECT
	*
FROM
	dw.customer_dim cd;  

--GEOGRAPHY

DROP TABLE IF EXISTS dw.geo_dim ;

CREATE TABLE dw.geo_dim
(
 geo_id serial NOT NULL,
 country VARCHAR(13) NOT NULL,
 city VARCHAR(17) NOT NULL,
 state VARCHAR(20) NOT NULL,
 postal_code VARCHAR(20) NULL, --can't be integer, we lost first 0
 CONSTRAINT PK_geo_dim PRIMARY KEY (geo_id));

--deleting rows
TRUNCATE TABLE dw.geo_dim;

--generating geo_id and inserting rows from orders
INSERT INTO dw.geo_dim 

SELECT
	100+ROW_NUMBER() OVER(), country, city, state, postal_code
FROM
	(SELECT DISTINCT country, city, state, postal_code FROM stg.orders) a;

--data quality check
SELECT DISTINCT
	country,
	city,
	state,
	postal_code
FROM
	dw.geo_dim
WHERE
	country is null or city is null or postal_code is null;

-- City Burlington, Vermont doesn't have postal code
UPDATA dw.geo_dim
SET postal_code = '05401'
WHERE
	city = 'Burlington' and postal_code is null;

--also update source file
UPDATE stg.orders
SET postal_code = '05401'
WHERE
	city = 'Burlington' and postal_code is null;


SELECT
	*
FROM
	dw.geo_dim
WHERE
	city = 'Burlington';

--PRODUCT

--creating a table
DROP TABLE IF EXISTS dw.product_dim ;

CREATE TABLE dw.product_dim
(prod_id serial NOT NULL, --we created surrogated key
product_id VARCHAR(50) NOT NULL,  --exist in ORDERS table
product_name VARCHAR(127) NOT NULL,
category VARCHAR(15) NOT NULL,
sub_category VARCHAR(11) NOT NULL,
segment VARCHAR(11) NOT NULL,
CONSTRAINT PK_product_dim PRIMARY KEY (prod_id));

--deleting rows
TRUNCATE TABLE dw.product_dim ;

--inserting
INSERT INTO dw.product_dim 
SELECT
	100+ROW_NUMBER() OVER () AS prod_id ,product_id, product_name, category, subcategory, segment
FROM (SELECT DISTINCT product_id, product_name, category, subcategory, segment FROM stg.orders) a;

--checking
SELECT
	*
FROM
	dw.product_dim cd;

--CALENDAR use function instead 

--creating a table
DROP TABLE IF EXISTS dw.calendar_dim ;

CREATE TABLE dw.calendar_dim
(dateid serial NOT NULL,
year int NOT NULL,
quarter int NOT NULL,
month int NOT NULL,
week int NOT NULL,
date date NOT NULL,
week_day VARCHAR(20) NOT NULL,
leap VARCHAR(20) NOT NULL,
CONSTRAINT PK_calendar_dim PRIMARY KEY (dateid));

--deleting rows
TRUNCATE TABLE dw.calendar_dim;
--
INSERT INTO dw.calendar_dim 
SELECT
TO_CHAR (date,'yyyymmdd')::int as date_id,
		extract('year' from date)::int as year,
        extract('quarter' from date)::int as quarter,
        extract('month' from date)::int as month,
        extract('week' from date)::int as week,
        date::date,
        to_char(date, 'dy') as week_day,
        extract('day' from
               (date + interval '2 month - 1 day')) = 29 as leap
FROM
	generate_series(date '2000-01-01',
					date '2030-01-01',
                    interval '1 day') as t(date);

--checking
SELECT
	*
FROM
	dw.calendar_dim; 

--METRICS

--creating a table
DROP TABLE IF EXISTS dw.sales_fact ;

CREATE TABLE dw.sales_fact
(sales_id serial NOT NULL,
cust_id integer NOT NULL,
order_date_id integer NOT NULL,
ship_date_id integer NOT NULL,
prod_id  integer NOT NULL,
ship_id     integer NOT NULL,
geo_id      integer NOT NULL,
order_id    varchar(25) NOT NULL,
sales       numeric(9,4) NOT NULL,
profit      numeric(21,16) NOT NULL,
quantity    int4 NOT NULL,
discount    numeric(4,2) NOT NULL,
CONSTRAINT PK_sales_fact PRIMARY KEY ( sales_id ));

INSERT INTO dw.sales_fact 
SELECT
	100+ROW_NUMBER() OVER() AS sales_id,
	cust_id,
	to_char(order_date,'yyyymmdd')::int as  order_date_id,
	to_char(ship_date,'yyyymmdd')::int as  ship_date_id,
	p.prod_id,
	s.ship_id,
	geo_id,
	o.order_id,
	sales,
	profit,
    quantity,
	discount
FROM
	stg.orders o 
INNER JOIN
	dw.shipping_dim s on o.ship_mode = s.shipping_mode
INNER JOIN
	dw.geo_dim g on o.postal_code = g.postal_code and g.country=o.country and g.city = o.city and o.state = g.state --City Burlington doesn't have postal code
INNER JOIN
	dw.product_dim p on o.product_name = p.product_name and o.segment=p.segment and o.subcategory=p.sub_category and o.category=p.category and o.product_id=p.product_id 
INNER JOIN
	dw.customer_dim cd on cd.customer_id=o.customer_id and cd.customer_name=o.customer_name 


--do you get 9994rows?
SELECT
	COUNT(*)
FROM
	dw.sales_fact sf
INNER JOIN
	dw.shipping_dim s on sf.ship_id=s.ship_id
INNER JOIN
	dw.geo_dim g on sf.geo_id=g.geo_id
INNER JOIN
	dw.product_dim p on sf.prod_id=p.prod_id
INNER JOIN
	dw.customer_dim cd on sf.cust_id=cd.cust_id;