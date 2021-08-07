/*
Overview (����� �������� ������)
- Total Sales
- Total Profit
- Profit Ratio
- Avg. Discount
*/

SELECT 
	ROUND(SUM(sales), 0) AS �������,
	ROUND(SUM(profit), 0) AS �������,
	ROUND(SUM(profit) / SUM(sales), 3) AS �����,
	ROUND(AVG(discount), 3) AS ������
FROM
	public.orders o
	LEFT JOIN public.returns r
	ON o.order_id = r.order_id
WHERE r.order_id IS NULL;


--Profit per Order

SELECT 
	order_id,
	ROUND(SUM(profit), 0) AS �������
FROM public.orders AS o
GROUP BY order_id
ORDER BY ������� DESC;


--Sales per Customer

SELECT 
	customer_id,
	customer_name,
	ROUND(SUM(sales), 0) AS �������
FROM public.orders AS o
GROUP BY customer_id, customer_name
ORDER BY ������� DESC;


--Monthly Sales by Segment

SELECT 	
	EXTRACT(YEAR FROM order_date) AS ���,
	EXTRACT(MONTH FROM order_date) AS �����,
	segment AS �������,
	ROUND(SUM(sales), 0) AS �������
FROM public.orders AS o
GROUP BY 1, 2, 3
ORDER BY 1, 2;

/*
Monthly Sales by Product Category
*/

SELECT 	
	EXTRACT(YEAR FROM order_date) AS ���,
	EXTRACT(MONTH FROM order_date) AS �����,
	category AS ���������,
	round(SUM(sales), 0) AS �������
FROM public.orders
GROUP BY 1, 2, 3
ORDER BY 1, 2;