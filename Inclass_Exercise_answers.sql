use banking;
#Q1. Print product, price, sum of quantity more than 5 sold during all three months.  

select product, price, sum(quantity) Total_Qty
from	bank_inventory_pricing
group by product, price
having Total_Qty > 5;

select product, price, sum(quantity) 
from bank_inventory_pricing group by product having sum(quantity)>5;

#Q2.Print product, quantity , month and count of records for which 
#   estimated_sale_price is less than purchase_cost 
describe bank_inventory_pricing;
select	product, quantity, month, count(*) total_records
from	bank_inventory_pricing
where	ifnull(Estimated_sale_price,0) < ifnull(purchase_cost,0)
group by
	product, quantity , month;
    
#Q3. Extarct the 3rd highest value of column Estimated_sale_price 
#    from bank_inventory_pricing dataset
select 	Estimated_sale_price 
		from 	bank_inventory_pricing
        order by Estimated_sale_price desc
        limit 3;
select min(Estimated_sale_price)
from	(select 	ifnull(Estimated_sale_price,0) Estimated_sale_price
		from 	bank_inventory_pricing
        order by Estimated_sale_price desc
        limit 3) ip;
        
select estimated_sale_price from (
	select distinct ifnull(estimated_sale_price,0) estimated_sale_price, dense_rank() 
	over(order by estimated_sale_price desc ) r 
	from bank_inventory_pricing) t
where r=3;
select estimated_sale_price, dense_rank() 
	over(order by estimated_sale_price desc) r 
	from bank_inventory_pricing;
    
#Q4. Count all duplicate values of column Product from table bank_inventory_pricing

select product, count(product)
from bank_inventory_pricing
group by product
having count(product) > 1;

#Q5. Create a view 'bank_details' for the product 'PayPoints' and Quantity is greater than 2
create or replace view bank_details as
 	select * from bank_inventory_pricing
    where product = 'PayPoints' and
		Quantity > 2;
select * from bank_details;     

describe bank_inventory_pricing;

SELECT 
    table_name, 
    is_updatable
FROM
    information_schema.views
WHERE
    table_schema = 'banking'; 
    
#Q6 Update view bank_details1 and add new record in bank_details1.
# -- --example(Producct=PayPoints, Quantity=3, Price=410.67)
create or replace view bank_details1 as
	select * from bank_inventory_pricing 
    where quantity > 5;
select * from bank_details1;    
insert into bank_details1(product, quantity, price) values ('PayPoints', 5, 410.67); 
select * from bank_details1;   
insert into bank_details1 values ('PayPoints', 3, 410.67,price * quantity, round(purchase_cost * 1.15,2), 2);
delete from bank_details where product = "PayPoints" and Quantity = 3;
select * from bank_details;

#Q7.Real Profit = revenue - cost  Find for which products, 
#   branch level real profit is more than the estimated_profit in Bank_branch_PL.
select branch, product  Real_profit from bank_branch_pl
where (revenue-cost) > Estimated_profit;


select branch, product,  (revenue - cost) real_profit, 
		((revenue - cost) - estimated_profit) diff   
from bank_branch_pl
where ((revenue - cost) - estimated_profit) > 0;

#Q8. Find the least calculated profit earned during all 3 periods
select month, min(revenue-cost) Real_profit 
from bank_branch_pl
group by month
#having min(revenue-cost) > 0
order by month;

# Q10
	select * from bank_account_details
    where account_type like '%card%';
#Q9. In Bank_Inventory_pricing, 
#-- a) convert Quantity data type from numeric to character 
#-- b) Add then, add zeros before the Quantity field. 

alter table bank_inventory_pricing modify quantity char(5);
select lpad(quantity,5,'0') from bank_inventory_pricing;

#Q11.Reduce 30% of the cost for all the products and print the products
#    whose  calculated profit at branch is exceeding estimated_profit .
select 	Branch, 
		Product, 
        cost, 
        revenue, 
		Estimated_profit, 
        (revenue - (cost * .7)) as Calculated_profit
from	bank_branch_pl
where 	(revenue - (cost * .7)) > Estimated_profit;
        
#Q12.Write a MySQL query to print the observations from the 
#    Bank_Inventory_pricing table excluding the values “BusiCard” And “SuperSave” 
#    from the column Product
select  * from bank_inventory_pricing
where Product not in ('BusiCard','SuperSave');

#Q13. Extract all the columns from Bank_Inventory_pricing 
#     where price between 220 and 300     
select  * from bank_inventory_pricing
where Price between 220 and 300;   

#Q14. Display all the non duplicate fields in the Product 
#     form Bank_Inventory_pricing table and display first 5 records.

select distinct Product from bank_inventory_pricing limit 5;

#Q15.Update price column of Bank_Inventory_pricing with an increase of 15%  
#    when the quantity is more than 3.
start transaction;
	select product, price, quantity from bank_inventory_pricing;
	update bank_inventory_pricing set
		price = round(price * 1.15,2)
	where quantity > 3;  
	select product, price, quantity from bank_inventory_pricing;  
commit;

#16---
select product, quantity, ifnull(round(price),0)
from bank_inventory_pricing;

#17---
describe bank_inventory_pricing;
alter table bank_inventory_pricing modify Product varchar(30) not null;

#18---
select product, quantity, price, round((price + 100),2) new_price 
from bank_inventory_pricing
where quantity > 3 and
	  price is not null;

#19---
select * from bank_account_details b
where b. Account_type = "SAVINGS" and
	 exists (select customer_id from bank_account_details b1
				where b1.account_type like '%Card%' and
						b1.Customer_id = b.customer_id);
                
#20--
select ac.customer_id, tr.account_number, ac.account_type, 
tr.transaction_amount
from bank_account_transaction tr
inner join bank_account_details ac 
on tr.account_number = ac.account_number;
use inclass;
select ac.customer_id, tr.account_number, ac.account_type, 
tr.transaction_amount, ar.linking_account_number
from bank_account_transaction tr
inner join bank_account_details ac 
on tr.account_number = ac.account_number
inner join bank_account_relationship_details ar
on tr.account_number = ar.account_number and
   ar.customer_id = ac.customer_id;

#21--
select customer_id, account_number, account_type 
from	bank_account_details
where 	account_type like '%card%';

select account_number, sum(transaction_amount)
from	bank_account_transaction
where account_number in 
	(select account_number from bank_account_relationship_details 
     where account_type like '%card%')
group by account_number;

## 22----

select month( curdate());
select cm.account_number, cm.tran_latest_month, cm.lm_transaction_amount,
		pm.tran_previous_month, pm.pm_transaction_amount
from 	(select 
	tr1.account_number,  
    month(tr1.transaction_date) tran_latest_month, 
    sum(tr1.transaction_amount) lm_transaction_amount,
    'current' identifier
from bank_account_transaction tr1
where month(tr1.transaction_date) = (select max(month(in_tr1.transaction_date)) 
				from bank_account_transaction in_tr1 
                where in_tr1.account_number = tr1.account_number) 
group by tr1.account_number) cm
left join 
(select 
	tr1.account_number,  
    max(month(tr1.transaction_date)) tran_previous_month, 
    sum(tr1.transaction_amount) pm_transaction_amount,
    'previous' identifier
from bank_account_transaction tr1
where month(tr1.transaction_date) < (select max(month(in_tr1.transaction_date)) 
				from bank_account_transaction in_tr1 
                where in_tr1.account_number = tr1.account_number) 
group by account_number) pm
on cm.account_number = pm.account_number;

## Q24 ---
select count(*) 
from	bank_account_transaction tr
inner join bank_account_details ac
on tr.account_number = ac.account_number and
	ac.account_type like '%card%';

select tr.account_number, ac.account_type, tr.transaction_date
from bank_account_transaction tr
inner join bank_account_details ac
where tr.account_number = ac.account_number and
	ac.account_type like '%card%';
    
    
##  25 --
select e.employee_id , first_name ,last_name phone_number ,salary, job_id
from employee_details e 
inner join department_details d on
d.department_id = e.department_id and
d.department_name = 'Contracting';

#Q26---
select temp.customer_id, count(*) No_of_records
from 
	bank_account_transaction tr, 
    (select customer_id, account_number from bank_account_details
	where customer_id in (select customer_id from bank_account_details ac1
						where ac1.account_type = 'SAVINGS' and 
							exists (select 1 from bank_account_details ac2 
									where ac2.customer_id = ac1.customer_id and
											ac2.account_type = 'RECURRING DEPOSITS')) and
										account_type in ('SAVINGS','RECURRING DEPOSITS')) temp
where tr.Account_Number = temp.Account_Number
group by temp.customer_id
having count(*) > 4;    
	
## Q27
 select employee_id, first_name, last_name, phone_number, email, job_id
 from 	employee_details
 where job_id <> 'IT_PROG';
 
 ## Q29
 ## I guess the question is wrong.  It should be department_id in the filtering
 ## condition than manager_id.
 select employee_id, first_name, last_name, phone_number, salary, job_id
 from 	employee_details
 where department_id = 60;
 
 #Q30---
drop table if exists emp_dept;
 create table emp_dept as
	select e.*, d.department_name from employee_details e
    inner join department_details d on
    d.department_id = e.department_id;
select * from emp_dept;    