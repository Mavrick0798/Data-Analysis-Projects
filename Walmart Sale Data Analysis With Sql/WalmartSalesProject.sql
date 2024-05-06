use salesdatawalmart;

/*creating a table sales */

create table sales (
invoice_id varchar(30) not null primary key,
branch varchar (5) not null,
city varchar(30)not null,
customer_type varchar(30) not null,
gender varchar (30) not null,
product_line varchar (100) not null,
unit_price decimal (10,2) not null,
quantity int not null,
VAT float(6,4) not null,
total_revenue decimal (12,4) not null,
date datetime not null,
time time not null,
payment_method varchar (15) not null,
cogs decimal (10,2) not null,
gross_margin_pct float (11,9),
gross_income decimal(12,4) not null,
rating float (2,1));

-- ---------Data Cleaning-----------------

select * from sales;
-- ------------------------feature Engineering-----------------------------------------
					  -- ----time_of_day--------------
select time, (case
				when time between "00:00:00" and "12:00:00" then "Morning"
                when time between "12:01:00" and "16:00:00" then "Afternoon" 
                else "Evening" 
			end) as time_of_date 
from sales;
alter table sales add column time_of_day varchar (20);
update sales
set time_of_day =  (case
				when time between "00:00:00" and "12:00:00" then "Morning"
                when time between "12:01:00" and "16:00:00" then "Afternoon" 
                else "Evening" 
			end
            );
-- -------------------------Day_name----------------------------------------------------------
select date, dayname(date)
from sales;
alter table sales add column day_name varchar(20);
update sales
set day_name = dayname(date);

-- -----------------------Month_Name------------------------------------------------------------
select date, monthname(date) from sales;
alter table sales add column month_name varchar(10);
update sales
set month_name = monthname(date);

-- -----------------------------------------------------------------------------------------------


-- -------------------------------Generic Questions-----------------------------------------------


-- --------------------------how many unique cities does the data have?----------------------------
select distinct city from sales;


-- -------------------------------In which city is each branch?-----------------------------------
select distinct city, branch from sales;
-- ------------------------------------------------------------------------------------------------


-- --------------------------------------Product Questions-----------------------------------------
-- -------------------------------How many unique product lines does the data have?----------------

select distinct product_line from sales;

-- -------------------------------What is the most common payment method?----------------------------

select payment_method, 
count(payment_method) as Payment_count
from sales 
group by payment_method
order by Payment_count desc;

-- -------------------------------What is the most selling product line?--------------------------------
SELECT 
    product_line, COUNT(product_line) AS Product_count
FROM
    sales
GROUP BY product_line
ORDER BY Product_count DESC;

-- -------------------------------What is the total revenue by month?--------------------------------
select
	month_name as month,
	sum(total_revenue) as total_revenue
from sales
group by month_name
order by total_revenue  desc;


-- -------------------------------What month had the largest COGS?--------------------------------

select month_name,
sum(cogs) as Cogs_count
from sales 
group by month_name
order by Cogs_count desc;

-- -------------------------------What product line had the largest revenue?--------------------------------

select product_line,
sum(total_revenue) as Total_revenue
from sales 
group by product_line
order by Total_revenue desc;

-- -------------------------------What is the city with the largest revenue?--------------------------------

select city,
sum(total_revenue) as Total_revenue
from sales
group by city
order by Total_revenue desc;

-- -------------------------------What product line had the largest VAT?--------------------------------

select product_line,
avg(vat) as avg_vat
from sales
group by product_line
order by avg_vat desc;

-- -------------------------------Which branch sold more products than average product sold?--------------------------------

select branch , city, 
sum(quantity) as Total_products_sold
from sales 
group by branch, city
having sum(quantity) > (select avg(quantity) from sales);

-- -------------------------------What is the most common product line by gender?--------------------------------

select  gender, product_line,
count(product_line) as Categories
from sales 
group by gender, product_line
order by Categories desc;

-- -------------------------------What is the average rating of each product line?--------------------------------

select product_line,
round(avg(rating),2) as Avg_Rating
from sales 
group by product_line
order by Avg_Rating desc;

-- -------------------------------Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales-------------------------------

select product_line,
round(avg(total_revenue),2) as avg_sales,
(case
when sum(total_revenue)> (select avg(total_revenue) from sales) then "good"
else "bad"
end) as Sales_review
from sales 
group by product_line;

-- ----------------------------------------------------------------------------------------------------------------------
				 -- -------------------------------Sales--------------------------------

-- -------------------------------Number of sales made in each time of the day per weekday--------------------------------

select time_of_day,
count(total_revenue) as no_of_sales
from sales
where day_name = "Sunday"
group by time_of_day
order by no_of_sales desc;

-- -------------------------------Which of the customer types brings the most revenue?--------------------------------

select customer_type,
round(sum(total_revenue),2) as total_revenue
from sales
group by customer_type
order by total_revenue desc;

-- -------------------------------Which city has the largest tax percent/ VAT (Value Added Tax)?--------------------------------

select city,
round(avg(vat),3) as Tax
from sales
group by city
order by Tax desc;

-- -------------------------------Which customer type pays the most in VAT?--------------------------------

select customer_type,
round(avg(vat),3) as Tax
from sales 
group by customer_type
order by Tax desc;

-- ----------------------------------------------------------------------------------------------------------------------
				 -- -------------------------------Customer--------------------------------

-- -------------------------------How many unique customer types does the data have?--------------------------------

select distinct customer_type from sales;     

-- -------------------------------How many unique payment methods does the data have?-------------------------------- 

select distinct payment_method from sales;

-- -------------------------------What is the most common customer type?--------------------------------

select customer_type, 
count(customer_type) as no_count
from sales 
group by customer_type
order by no_count desc;     

-- -------------------------------Which customer type buys the most?--------------------------------

select customer_type, 
count(customer_type) as no_count
from sales 
group by customer_type
order by no_count desc; 

-- -------------------------------What is the gender of most of the customers?--------------------------------

select gender, 
count(gender) as Gender_count
from sales 
group by gender
order by Gender_count desc;

-- -------------------------------What is the gender distribution per branch?--------------------------------

select branch,gender, 
count(gender) as Gender_count
from sales 
group by branch,gender;

-- or--
select gender, 
count(gender) as Gender_count
from sales 
where branch = 'A'
group by gender
order by Gender_count desc;

-- -------------------------------Which time of the day do customers give most ratings?--------------------------------

select time_of_day,
round(avg(rating),2) as no_of_rating
from sales
group by time_of_day;

-- -------------------------------Which time of the day do customers give most ratings per branch?--------------------------------

select time_of_day,
round(avg(rating),2) as no_of_rating
from sales
where branch = 'A'
group by time_of_day
order by no_of_rating desc;

-- -------------------------------Which day fo the week has the best avg ratings?--------------------------------

select day_name,
round(avg(rating),3) as no_of_rating
from sales
group by day_name
order by no_of_rating desc;

-- -------------------------------Which day of the week has the best average ratings per branch?--------------------------------

select day_name,
round(avg(rating),3) as no_of_rating
from sales
where branch = 'B'
group by day_name
order by no_of_rating desc;

-- ---------------------------------------------------------------------------------------------------------------------------------

