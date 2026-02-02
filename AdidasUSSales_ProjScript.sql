
# Add a new column to store the standardized date
alter table adidasussales
add column invoice_date_std DATE;

# Populate it using STR_TO_DATE
set SQL_SAFE_UPDATES = 0;

update adidasussales
set invoice_date_std = case
    when invoice_date like '%-%' 
         then str_to_date(invoice_date, '%d-%m-%Y')
    when invoice_date like '%/%' 
         then str_to_date(invoice_date, '%d/%m/%Y')
end
where invoice_date is not NULL;

# 1.1 State-wise comparison on gender-based sales

with t1 as (
select state, sum(total_sales) as men_sales
from adidasussales
where Product like "%Men%"
group by state
),
t2 as (
select state, sum(total_sales) as women_sales
from adidasussales
where Product like "%Women%"
group by state
)
select t1.state, men_sales, women_sales, men_sales - women_sales as diff
from t1
inner join t2
on t1.state = t2.state
order by diff desc;

# 1.2 State and city-wise comparison on gender-based sales

with t1 as (
select state, city, sum(total_sales) AS men_sales
from adidasussales
where Product like '%Men%'
group by state, city
),
t2 as (
select state, city, sum(total_sales) as women_sales
from adidasussales
where Product like '%Women%'
group by state, city
)
select t1.state, t1.city, men_sales, women_sales, men_sales - women_sales AS diff
from t1
inner join t2
on t1.state = t2.state and t1.city = t2.city
order by t1.state, diff desc;

# 1.3 gender based comparison for footwear vs apparel sales

with t1 as (
select substring_index(product, ' ', 1) as gender,
case when product like '%Footwear%' then total_sales else 0 end as footwear_sales,
case when product like '%Apparel%' then total_sales else 0 end as apparel_sales
from adidasussales
where product like '%Footwear%' or product like '%Apparel%'
) 
select gender, sum(footwear_sales) as footwear_sales, 
sum(apparel_sales) as apparel_sales, sum(footwear_sales) - sum(apparel_sales) as diff
from t1
group by gender
order by diff desc;

# 1.4 Total sales comparison between men and women

select men_sales, women_sales, men_sales - women_sales
from(
select sum(case when product like '%men%' then total_sales else 0 end) as men_sales
from adidasussales
) as sub1,
(
select sum(case when product like '%women%' then total_sales else 0 end) as women_sales
from adidasussales
) as sub2;

# 2.1 Year-wise comparison between footwear and apparel

with t1 as (
select year(invoice_date_std) as year, sum(total_sales) as footwear_sales
from adidasussales
where product like '%footwear%'
group by year
),
t2 as (
select year(invoice_date_std) as year, sum(total_sales) as apparel_sales
from adidasussales
where product like '%apparel%'
group by year
)
select 
t1.year, footwear_sales, apparel_sales, footwear_sales - apparel_sales as diff
from t1
inner join t2
on t1.year = t2.year
order by t1.year;

# 2.2 State-wise comparison between footwear and apparel

with t1 as (
select state, sum(total_sales) as footwear_sales
from adidasussales
where Product like '%Footwear%'
group by state
),
t2 as (
select state, sum(total_sales) as apparel_sales
from adidasussales
where Product like '%Apparel%'
group by state
)
select 
t1.state, footwear_sales, apparel_sales, footwear_sales - apparel_sales AS diff
from t1 
inner join t2 
on t1.state = t2.state
order by diff desc;

# 2.3 City-wise comparison between footwear and apparel

with t1 as (
select state, city, sum(total_sales) as footwear_sales
from adidasussales
where Product like '%Footwear%'
group by state, city
),
t2 as (
select state, city, sum(total_sales) as apparel_sales
from adidasussales
where Product like '%Apparel%'
group by state, city
)
select t1.state, t2.city, footwear_sales, apparel_sales, footwear_sales - apparel_sales AS diff
from t1
inner join t2
on t1.state = t2.state and t1.city = t2.city
order by t1.state, diff desc;

# 2.4 Total Sales comparison between apparel and footwear

select footwear_sales, apparel_sales, footwear_sales - apparel_sales
from(
select sum(case when product like '%Footwear%' then total_sales else 0 end) as footwear_sales
from adidasussales
) as sub1,
(
select sum(case when product like '%Apparel%' then total_sales else 0 end) as apparel_sales
from adidasussales
) as sub2;

# 3.1 Which retailer had the best operating profit?

select Retailer, avg(Operating_Profit) as Avg_Profit
from adidasussales
group by Retailer
order by Avg_Profit desc;

# 3.2 Which retailer sold the most units?

select Retailer, sum(Units_Sold) as Total_Units_Sold
from adidasussales
group by Retailer
order by Total_Units_Sold desc;

# 3.3 Which retailer has the lowest average price (not per product type)?

select Retailer, avg(Price_per_Unit) as Avg_Price_Per_Unit
from adidasussales
group by Retailer
order by Avg_Price_Per_Unit desc;

# 4.1 Which type of product had the highest price per unit

select Product, avg(Price_per_Unit) as Avg_Price_Per_Unit
from adidasussales
group by Product
order by Avg_Price_Per_Unit desc;

# 4.2 For each product, which retailer has the lowest average price of that product type?

select Product, Retailer, avg_price
from (
select Product, Retailer, avg(Price_per_Unit) as avg_price,
row_number() over (partition by Product order by avg(Price_per_Unit) asc) as price_rank
from adidasussales
group by Product, Retailer
) as t1
where price_rank = 1;

# 5.1 total sales, units sold, profit per region

with t1 as
(select region, 
sum(units_sold) as total_units_sold,
sum(total_sales) as total_sales,
sum(operating_profit) as op_profit
from adidasussales
group by region)
select *
from t1;

# 5.2 total average sales, units sold and profit per region

select avg(total_units_sold) as totalavg_units_sold, 
avg(total_sales) as total_avg_sales, avg(op_profit) as totalavg_op_profit  
from
(select region,
sum(units_sold) as total_units_sold,
sum(total_sales) as total_sales,
sum(operating_profit) as op_profit
from adidasussales
group by region) as sub1;

# 6.1 total number of units sold, total sales and total profit based on state

with t1 as
(select state, 
sum(units_sold) as total_units_sold,
sum(total_sales) as total_sales,
sum(operating_profit) as op_profit
from adidasussales
group by state)
select *
from t1;

# 6.2 overall average of units sold, total sales and total profit based on state

select avg(total_units_sold) as totalavg_units_sold, 
avg(total_sales) as total_avg_sales, avg(op_profit) as totalavg_op_profit  
from
(select state,
sum(units_sold) as total_units_sold,
sum(total_sales) as total_sales,
sum(operating_profit) as op_profit
from adidasussales
group by state) as sub1;

# 7.1 total number of units sold, total sales and total profit based on city

with t1 as 
(select state, city, 
sum(units_sold) as total_units_sold,
sum(total_sales) as total_sales,
sum(operating_profit) as total_profit
from adidasussales
group by state, city)
select * from t1;

# 7.2 overall average of units sold, total sales and total profit for city

select avg(total_units_sold) as avg_for_city, 
avg(total_sales) as avg_sales, avg(total_profit) as avg_profit 
from
(select state, city, 
sum(units_sold) as total_units_sold,
sum(total_sales) as total_sales,
sum(operating_profit) as total_profit
from adidasussales
group by state, city) as sub1;

# 8.1 Revenue and operating profit comparison by sales method

select Sales_Method, sum(Total_Sales) as Revenue, 
round(sum(Operating_Profit),2) as Profit
from adidasussales
group by Sales_Method;

# 8.2 Revenue, operating profit, sales percentage proportion, and operating profit percentage proportion by sales method

select sales_method,SUM(total_sales) AS method_sales,
round(sum(Operating_Profit),2) AS method_profit,
round(sum(total_sales) * 100.0 / sum(sum(total_sales)) OVER (), 0) AS Sales_Pct,
ROUND(SUM(Operating_Profit) * 100.0 / Sum(SUM(Operating_Profit)) OVER (), 0) AS Profit_Pct
from adidasussales
group by sales_method;

# 9.1 sales and operating profit comparison by month and year

select  
year(invoice_date_std) as yeard, month(invoice_date_std) as monthd,   
sum(units_sold) as total_units_sold, sum(total_sales) as total_sales, 
round(sum(operating_profit), 2) as total_operating_profit
from adidasussales
group by yeard, monthd
order by yeard, monthd;

# 9.2 Percentage change in total sales and operating profit by year (2020 vs 2021)

select ((total_sales_2021 - total_sales_2020) * 100 / total_sales_2020) as pctchg_total_sales,
((operating_profit_2021 - operating_profit_2020) * 100 / operating_profit_2020) as pctchg_operating_profit
from
(
select  
year(invoice_date_std) as year_val, sum(total_sales) as total_sales_2020,  
round(sum(operating_profit), 2) as operating_profit_2020
from adidasussales
where year(invoice_date_std) = 2020
group by year_val
) as data20,
(
select  
year(invoice_date_std) as year_val, sum(total_sales) as total_sales_2021,  
round(sum(operating_profit), 2) as operating_profit_2021
from adidasussales
where year(invoice_date_std) = 2021
group by year_val
) as data21;

# 10.1 Best and low performing products 
select product, year(invoice_date_std) as year_val, sum(total_sales) as revenue
from adidasussales
group by product, year_val
order by revenue desc;

# 10.2 Avg Price of each product, % of units sold and % of revenue earned
select Product,avg(Price_per_Unit) as Avg_Price,
sum(Units_Sold) as Total_units,
sum(Total_sales) as Revenue,
round(sum(Units_Sold)*100 / sum(sum(Units_Sold)) over(), 0) as Total_units_Pct,
round(sum(Total_sales)*100 / sum(sum(Total_sales)) over(), 0) as Revenue_Pct
from adidasussales
group by Product;

# 11.1 State-wise distribution
select State, sum(Total_Sales) AS Revenue, round(sum(Operating_Profit),2) as Profit
from adidasussales
group by State
order by  profit desc, revenue desc;

