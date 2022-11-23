use employee_db;

## Inserting a single record
insert into employee 
	(emp_id, manager_id, first_name, last_name, gender, dept, job, exp)
	values ('E101','E101','John','Bill', 'M', 'IT','LEAD',10);
    
insert into employee 
	(emp_id, manager_id, first_name, last_name, gender, dept, job, exp)
	values 
    ('E102','E101','Amy','John', 'M', 'IT','Programmer',5),
    ('E103','E101','Smith','Scott', 'M', 'IT','Manager',12);    

select * from employee;  

select emp_id, full_name, dept, job, exp
from	employee;  

select emp_id, first_name, last_name 
from employee;

create table employee_demo(
	EMP_ID			char(4)		primary key,
    FIRST_NAME		varchar(25) 	not null,
    LAST_NAME		varchar(25)		not null,
    GENDER			char(1)			not null,
    ROLE			varchar(25)		not null,
    DEPT			varchar(25)		not null,
    EXP				tinyint			not null,
    COUNTRY			varchar(25)		NOT NULL,
	CONTINENT		varchar(25)		NOT NULL,
    SALARY			int				not null,
    EMP_RATING		tinyint			not null,
	MANAGER_ID		char(4)			not null);

select * from employee_demo;

select emp_id, first_name, last_name
from employee_demo
Where dept = 'AUTOMOTIVE';

select emp_id, first_name, last_name, role, dept
from employee_demo
Where dept = 'AUTOMOTIVE' and
	role like 'LEAD%';
    
select emp_id, first_name, last_name, role, dept
from employee_demo
Where dept in ('AUTOMOTIVE', 'FINANCE') and
	role like 'LEAD%';    
    
select emp_id, first_name, last_name, role, dept
from employee_demo
Where dept in ('AUTOMOTIVE', 'FINANCE') and
	exp <= 5;  
    
select emp_id, first_name, last_name, role, dept, exp
from employee_demo
Where dept in ('AUTOMOTIVE', 'FINANCE') and
	exp between 5 and 10; 
    
select emp_id, first_name, last_name, role, dept, exp
from employee_demo
Where dept in ('AUTOMOTIVE', 'FINANCE') and
	exp != 10; 
    
select distinct dept from employee_demo;    

select * from employee_demo limit 2;

select emp_id, first_name, last_name, role
from employee_demo
order by role;

select emp_id, first_name, last_name, role, exp
from employee_demo
order by exp desc, role;

select emp_id, first_name, last_name, dept, exp
from employee_demo
where dept = 'FINANCE' or
	exp > 5
order by dept;

select emp_id, first_name, last_name, role, exp
from employee_demo
where role not in ('MANAGER','PRESIDENT');

select dept, count(dept) as 'NO_Emp'
from employee_demo
group by dept;

select dept, count(dept) as 'NO_Emp'
from employee_demo
where dept in ('AUTOMOTIVE','RETAIL')
group by dept
having count(dept) >= 4;

select dept, role, sum(exp) 'Total_Exp'
from employee_demo
group by rollup(dept, role);

create table temp (
	id tinyint not null,
    nm	varchar(20));
    
insert into temp values (1, 'ABC'),(2,'XYZ'), (3, NULL), (4, NULL);    

select * from temp 
where nm is not null;

-- single line comment --

/* 
Multi line comment.
second line
*/