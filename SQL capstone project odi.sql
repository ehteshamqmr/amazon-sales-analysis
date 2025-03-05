CREATE DATABASE amazon;   #creating database and importing the data
USE amazon;
Select * from amazon;

SET SQL_SAFE_UPDATES = 0;  #for turning the safe mode off so that we can alter the table

# Adding monthname,dayname,datename as column and updating the value
Alter table amazon
Add column month_name varchar(10);

Update amazon
Set month_name=monthname(date);

Alter table amazon
Add column day_name varchar(20);

Update amazon
Set day_name=dayname(date);

Alter table amazon
Add column timeof_day varchar(10);

 # dividing the time in different session, so to get at which time more transaction happens
 
Update amazon
Set timeof_day=(case
                when time between '00:00:00' and '06:00:00' then 'Night'
                when time between '06:01:00' and '12:00:00' then 'Morning'
                when time between '12:01:00' and '18:00:00' then 'Afternoon'
                else 'Evening'
                end);
                
               
-- 1 What is the count of distinct cities in the dataset?

     Select count(distinct city) AS cities From amazon;
     
     # THREE cities has been included here

-- 2 For each branch, what is the corresponding city?

      Select distinct branch,city From amazon;
      
      # yangon,naypyitaw and mandalay has branches A,B and C respectively

-- 3 What is the count of distinct product lines in the dataset?

       Select count(distinct `product line`) as distinct_product_line from amazon;

       #there are 6 product line named as 
      --  1.Health and beauty,
--        2.Electronic accessories,
--        3.Sports and travel,
--        4.Home and lifestyle,
--        5.Food and beverages AND
--        6.Fashion accessories

-- 4. Which payment method occurs most frequently?
 
        Select max(payment) as frequent_payment
        from amazon;
        
        # Ewallet type of payment mode is frequently used
        
-- 5. Which product line has the highest sales?
       
        Select `product line`, sum(cogs) as sales_count
        from amazon
		group by `product line`
        order by sales_count desc
        limit 1;
        
        # Food and beverages is being sold maximum
        
-- 6 How much revenue is generated each month?

       Select month_name, sum(total) as revenue
       from amazon
       group by month_name
	   order by revenue desc;


-- 7 In which month did the cost of goods sold reach its peak?

       Select month_name,sum(cogs) as peak_sales from amazon
       group by month_name
	   order by peak_sales desc
       limit 1;
     
     # maximum goods is sold in the month of january

-- 8 Which product line generated the highest revenue?
       Select `product line`,sum(total) as total_revenue from amazon
       group by `product line`
       order by total_revenue desc
       limit 1;
-- 9 In which city was the highest revenue recorded?
      Select city,sum(total) as total_revenue from amazon
      group by city
      order by total_revenue desc
      limit 1;



-- 10 Which product line incurred the highest Value Added Tax?

      Select `product line`,sum(`tax 5%`) as total_vat_amount from amazon
      group by `product line`
      order by total_vat_amount desc
      limit 1;
      
      # highest vat is associated with  Food and beverages

-- 11 For each product line, add a column indicating "Good" if its sales are above average, otherwise "Bad."
       Select `product line`,
	   case
           when `gross income`> (select avg(`gross income`) from amazon) THEN 'good'
           else 'bad'
       end as kindofsale
       from amazon;
     
     
-- 12 Identify the branch that exceeded the average number of products sold.


      Select branch,sum(quantity) as total_quantity
      from amazon
      group by branch
      having total_quantity>(select avg(quantity) from amazon);
      
      # all three branches have exceded there average sale

-- 13 Which product line is most frequently associated with each gender?

WITH CTE AS
            (Select `product line`,gender,count(`invoice id`) as freq,
            row_number() over (partition by gender order by count(`invoice id`) desc) as obs
            from amazon
            group by `product line`,gender)
	  
select `product line`,gender, freq
from CTE
where obs=1;
      
       # for female maximum is Fashion accessories
       # for male maximum is Health and beauty
       
       
	-- 14 Calculate the average rating for each product line.

        Select `product line`, avg(rating) as avg_rating from amazon
        group by `product line`
        order by avg_rating desc;

-- 15 Count the sales occurrences for each time of day on every weekday. 

        Select day_name, timeof_day,count(*) as count_of_sale
        from amazon
        group by day_name, timeof_day
        order by day_name desc, count_of_sale desc;

-- 16 Identify the customer type contributing the highest revenue.
 
      Select `customer type`, sum(total) as rev from amazon
      group by `customer type`
      order by rev desc
      limit 1;
 
-- 17 Determine the city with the highest VAT percentage./
      Select city, sum(`tax 5%`) /sum(total)* 100 as vat_percentage
      from amazon
      group by city
      order by vat_percentage desc
      limit 1;
     
     # mandalay city has highest vat payment
     
-- 18 Identify the customer type with the highest VAT payments.

      Select `customer type`,sum(`tax 5%`) as vat_d  
      from amazon
      group by `customer type`
      order by vat_d desc
      limit 1;

-- 19 What is the count of distinct customer types in the dataset?

      select count(distinct `customer type`) as dis_c
      from amazon;

-- 20 What is the count of distinct payment methods in the dataset?

      select count(distinct payment) as dp from amazon;
 
 # there are three different mode of payment
 
-- 21 Which customer type occurs most frequently?

      select (`customer type`), count(`invoice id`) as frequency 
      from amazon
      group by `customer type`
      order by frequency desc
	  limit 1;
      
       #member type of purchase frequently
      
-- 22 Identify the customer type with the highest purchase frequency.
      select (`customer type`), sum(quantity) as purchase_frequency from amazon
      group by `customer type`
      order by purchase_frequency desc
      limit 1;
      
      # member type of purchase frequently

-- 23 Determine the predominant gender among customers.

      select gender,count(*) as purchase_frequency from amazon
      group by gender 
      order by purchase_frequency desc
      limit 1;
      
      # female is predominant customer

-- 24 Examine the distribution of genders within each branch.

      select branch,gender,count(`invoice id`) as freq from amazon
      group by branch,gender
      order by branch,freq desc;
      
      # almost every branch have gender equality

-- 25 Identify the time of day when customers provide the most ratings./

      select timeof_day,count(rating) as rating_count from amazon
      group by timeof_day
      order by rating_count desc
      limit 1;
      
      # in afternoon highest rating is being provided
      
-- 26 Determine the time of day with the highest customer ratings for each branch./

      select timeof_day,branch,count(rating) as h_rating 
      from amazon
      group by timeof_day,branch
      order by h_rating desc
      limit 1;

      # branch a has highest rating in afternoon
      
-- 27 Identify the day of the week with the highest average ratings.

      select day_name, avg(rating) as average_rating
      from amazon
      group by day_name
      order by average_rating desc
      limit 1;
      select * from amazon;
      
      # Monday have the highest rating with 7.153

-- 28 Determine the day of the week with the highest average ratings for each branch.

      select branch,day_name,average_rating
      from (
           select branch,day_name,avg(rating) as average_rating,
           row_number() over(partition by branch order by avg(rating) desc) as week_av
           from amazon
           group by branch,day_name
	 ) as ranked_day
     where week_av=1;
     
     # BRANCH A,B,C have highest rating on Friday,Monday and Friday respectively
     
     
#PRODUCT ANALYSIS  
-- 1. TOTAL 6 PRODUCT LINE ARE THERE
-- 2. BEST PERFORMING PRODUCT LINE IS 'FOOD AND BEVERAGES' HAVING REVENUE AROUND 'FIFTY SIX THOUSAND'
-- 3. 'HEALTH AND BEAUTY' NEEDS IMPROVEMENT HAVING LEAST REVENUE

#SALES ANALYSIS
-- --1.'NAYPITAW' CITY HAS ACHIEVED HIGHEST SALE IN THE MONTH OF JANUARY
-- --2.MONDAY MORNING RATING IS HIGH BUT SALE IS LOW
-- --3.IN SATURDAY AFTERNOON RATING IS LOW BUT SALE IS HIGH SO NEED TO WORK ON QUALITY

#CUSTOMER ANALYSIS

#1.female spend more than men
#2.membership type of customer purchase most