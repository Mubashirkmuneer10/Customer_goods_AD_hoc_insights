SELECT  market
FROM gdb023.dim_customer
where customer ="Atliq Exclusive" and region = "APAC"
#2
WITH cte AS (
    SELECT
        COUNT(DISTINCT CASE WHEN fiscal_year = 2020 THEN product_code END) AS unique_product_code_2020,
        COUNT(DISTINCT CASE WHEN fiscal_year = 2021 THEN product_code END) AS unique_product_code_2021
    FROM fact_sales_monthly
    WHERE fiscal_year IN (2020, 2021)
)
SELECT 
    unique_product_code_2020,
    unique_product_code_2021,
    (CAST(unique_product_code_2021 AS FLOAT) - unique_product_code_2020) / unique_product_code_2020 * 100 AS percentage
FROM cte;
# 3
select count(distinct product_code),segment
from dim_product
group by segment
order by count(distinct product_code) desc;

with cte as (SELECT 
    c.segment,
    COUNT(DISTINCT CASE WHEN m.fiscal_year = 2020 THEN m.product_code END) AS unique_code_2020,
    COUNT(DISTINCT CASE WHEN m.fiscal_year = 2021 THEN m.product_code END) AS unique_code_2021
FROM dim_product c
JOIN fact_sales_monthly m 
ON c.product_code = m.product_code
WHERE m.fiscal_year IN (2020, 2021)
GROUP BY c.segment)
select * ,
(unique_code_2020 - unique_code_2021 ) as difference
from cte

select p.product_code ,p.product,mc.manufacturing_cost
from dim_product p
join fact_manufacturing_cost mc
on p.product_code = mc.product_code
order by manufacturing_cost desc   

select c.customer,c.customer_code,avg(pre_invoice_discount_pct) as average
from dim_customer c
join fact_pre_invoice_deductions pd
on c.customer_code = pd.customer_code
where market ="india" and fiscal_year = 2021
group by c.customer_code,c.customer
order by average desc limit 5;  

SELECT  fm.fiscal_year,
(fm.sold_quantity *gp.gross_price)/1000 as gross_sale,
month(fm.date) as month 
FROM fact_sales_monthly fm 
JOIN fact_gross_price gp
ON fm.product_code = gp.product_code

SELECT 
    *,
    CASE
        WHEN MONTH(date) IN (1, 2, 3) THEN 'Q1'
        WHEN MONTH(date) IN (4, 5, 6) THEN 'Q2'
        WHEN MONTH(date) IN (7, 8, 9) THEN 'Q3'
         WHEN MONTH(date) IN (10, 11, 12) THEN 'Q4'
    END AS quarter
FROM 
    fact_sales_monthly
ORDER BY 
    sold_quantity DESC;
















