/* Задача 1
Создайте материализованное представление, показывающее продажи в разрезе продукта и месяца для последнего года в наборе данных. Последний год должен рассчитываться динамически. */

CREATE materialized VIEW public.vm_year_sales AS 
SELECT 
    product_name,
    YEAR,
    MONTH,
    sales
FROM (
    SELECT 
        product_name,
        EXTRACT (YEAR FROM o.order_date) AS YEAR,
        EXTRACT (MONTH FROM o.order_date) AS MONTH,
        SUM(od.unit_price * od.quantity) AS sales
FROM
	order_details od
JOIN
	products p ON od.product_id = p.product_id
JOIN
	orders o ON o.order_id = od.order_id
WHERE
	order_date = (SELECT max(order_date) FROM orders o)
GROUP BY
	product_name,
	YEAR,
   	MONTH) AS sales_data;


/* Задача 2
Напишите запрос, рассчитывающий долю продаж и ранг товара в рамках каждой категории. В запросе предварительно сгруппируйте продажи по названию и категории с помощью CTE. */

   WITH sales_data AS (
SELECT
	category_name,
    sum(od.quantity * od.unit_price) AS sales
FROM
	orders o
JOIN
	order_details od ON o.order_id = od.order_id
JOIN
	products p ON od.product_id = p.product_id
JOIN
	categories c ON c.category_id = p.category_id
GROUP BY
	category_name),
sales_ranks AS (
SELECT 
    category_name,
    sales,
    RANK() OVER(ORDER BY sales desc) AS rnk_sales_total
FROM
	sales_data)

SELECT
	* 
FROM
	sales_ranks;


/* Задача 3
Постройте запрос, показывающий суммарные продажи по категориям всего (первая колонка) и по клиентам из Германии (country = Germany, вторая колонка). Для расчета продаж в Германии используйте функцию CASE или FILTER */

SELECT
	ca.category_name,
    SUM(od.unit_price * od.quantity) AS total_sales,
    SUM(CASE WHEN
    	ship_country = 'Germany'
    	THEN od.unit_price * od.quantity END) AS sales_in_germany
FROM
	orders o
JOIN
	order_details od ON o.order_id = od.order_id
JOIN
	customers c ON o.customer_id = c.customer_id
JOIN
	products p ON od.product_id = p.product_id
JOIN
	categories ca ON ca.category_id = p.category_id 	
GROUP BY
	ca.category_name;


/*Задача 4
Напишите запрос, который показывает продажи по месяцам и категориям 1997 года, в соседней колонке - продажи аналогичного периода прошлого года, а также суммарные итоги для всего набора данных и каждой категории. */

SELECT 
    c.category_name,
    EXTRACT(YEAR FROM o.order_date) AS year,
    EXTRACT(MONTH FROM o.order_date) AS month,
    SUM(od.unit_price * od.quantity) AS sales
FROM
	order_details od
JOIN
	orders o ON o.order_id = od.order_id
JOIN
	products p ON od.product_id = p.product_id
JOIN
	categories c ON c.category_id = p.category_id 
GROUP BY ROLLUP
	(c.category_name,
	YEAR,
	MONTH)
ORDER BY
	c.category_name;