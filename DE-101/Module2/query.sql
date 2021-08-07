/*
Overview (обзор ключевых метрик)
- Total Sales
- Total Profit
- Profit Ratio
- Avg. Discount
*/

SELECT 
	ROUND(SUM(sales), 0) AS Продажи,
	ROUND(SUM(profit), 0) AS Прибыль,
	ROUND(SUM(profit) / SUM(sales), 3) AS Маржа,
	ROUND(AVG(discount), 3) AS Скидка
FROM
	public.orders o
	LEFT JOIN public.returns r
	ON o.order_id = r.order_id
WHERE r.order_id IS NULL;


--Profit per Order

SELECT 
	order_id,
	ROUND(SUM(profit), 0) AS Прибыль
FROM public.orders AS o
GROUP BY order_id
ORDER BY Прибыль DESC;


--Sales per Customer

SELECT 
	customer_id,
	customer_name,
	ROUND(SUM(sales), 0) AS Продажи
FROM public.orders AS o
GROUP BY customer_id, customer_name
ORDER BY Продажи DESC;


--Monthly Sales by Segment

SELECT 	
	EXTRACT(YEAR FROM order_date) AS Год,
	EXTRACT(MONTH FROM order_date) AS Месяц,
	segment AS Сегмент,
	ROUND(SUM(sales), 0) AS Продажи
FROM public.orders AS o
GROUP BY 1, 2, 3
ORDER BY 1, 2;

/*
Monthly Sales by Product Category
*/

SELECT 	
	EXTRACT(YEAR FROM order_date) AS Год,
	EXTRACT(MONTH FROM order_date) AS Месяц,
	category AS Категория,
	round(SUM(sales), 0) AS Продажи
FROM public.orders
GROUP BY 1, 2, 3
ORDER BY 1, 2;