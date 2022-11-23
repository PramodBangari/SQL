## To create a database
create database if not exists employee_db;

## To use the created database to create other objects.
use employee_db;

## To display the current default database
select database();

## To display all the available database in the given server
show databases;

show tables;
## Creating an Employee tabse
create table if not exists employee (
	emp_id		char(4)		primary key,
    manager_id	char(4)		not null,
    first_name	varchar(30)	not null,
    last_name	varchar(30)	not null,
    dept		varchar(30) not null,
    role		varchar(30) not null
);

describe employee;

alter table employee add gender char(1) not null after last_name;

alter table employee add exp  tinyint not null check(exp > 0);

create table if not exists employee2 (
	emp_id		char(4)		primary key,
    manager_id	char(4)		not null,
    first_name	varchar(30)	not null,
    last_name	varchar(30)	not null,
    gender		char(1) 	not null,
    dept		varchar(30) not null,
    role		varchar(30) not null,
    exp			tinyint 	not null check(exp > 0),
    constraint gender_check check(gender in ('M','F','O'))
);

desc employee2;
show tables;

drop table if exists employee;
alter table employee2 rename to employee;

## Modifying the column definition
alter table employee 
	modify dept varchar(40) not null,
    modify role varchar(40) not null;
    
desc employee;   

## rename the column role to job
alter table employee change role job varchar(40) not null; 

alter table employee add full_name varchar(100)
	generated always as(concat(first_name, ' ',last_name));
    
insert into employee (emp_id, manager_id, first_name, last_name, gender, dept, job, exp)
 values ('E101','E101','John','Bill', 'M', 'IT','LEAD',10);
 
 select * from employee;
 
 truncate employee;  ## Deletes all the data from employee table
 
 create table temp1 (
	id	int);
create table temp2 (
	id1 int);
show tables;  
## Dropping multiple tables
drop table temp1, temp2;  