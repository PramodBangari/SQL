use sakila;

select * from category;

## Example of horizontal view
create or replace view cat_hor_view as
	select * from category 
    where name like 'c%';
    
select * from cat_hor_view;    
    
## Example of vertical view
create or replace view cat_ver_view as
		select category_id, name
        from category;
select * from cat_ver_view;    

desc payment; 

## example of grouped view.
create or replace view payment_by_yearmonth as
	select 	year(payment_date) year, 
			month(payment_date) month, 
			sum(amount) as Total_amount
    from payment
    group by year(payment_date), month(payment_date);
    
select * from payment_by_yearmonth
where year = 2005;    

use customer_info;

select * from customer;

create or replace view  NJ_customers as
	select * from customer
    where 	city = 'New Jersey';
    
select * from NJ_customers;   

insert into nj_customers values 
	(110, 'Bill','Cosby', 'California', 1234564728);
    
select * from customer;   

update nj_customers set
	telephone = 1234567890
where cust_id = 110;    

select * from product_sales;

create or replace view prod_commission as
	select *, sales * 0.15 as commission
    from product_sales;
    
select * from prod_commission;
    
