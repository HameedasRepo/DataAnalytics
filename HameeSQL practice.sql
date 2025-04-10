-- use parks_and_recreation;
select * from employee_demographics;
select * from employee_salary;
select first_name from employee_demographics;
--  #PEMDAS = paranthesis, exponential, Multiplication, Division, Addition and Subtraction
select distinct gender from employee_demographics; #Disticnct gives Unique values
select distinct first_name,gender from employee_demographics; 
#doesn't give unique values but take a row of values as an unique value
----------------------------------------------------------------
## WHERE CLAUSE
select * from employee_salary where salary > 50000;
select * from employee_demographics where gender != 'Female';
----------------------------------------------------------------
## LOGICAL OPERATORS   AND, OR, NOT
select * from employee_demographics where (first_name = 'Leslie' AND age ='44') or age>55;
---------------------------------------------------------------
## LIKE Statement
## %(anything or any number of characters), _(specific no of characters)

select * from employee_demographics where first_name Like 'a__';
select * from employee_demographics where first_name Like '%er%';
select * from employee_demographics where first_name Like 'a___%';
select * from employee_demographics where birth_date Like '1989%';
------------------------------------------------------------------
## Group By or Order By
--  to group same rows and run aggregate functions on those
select gender from employee_demographics Group by gender;
select distinct gender from employee_demographics;
-- what group by is doing it rolls up all the values of the column and let perform aggregate 
-- functions like MIN, MAX, AVG

select gender, AVG(age) from employee_demographics group by gender;
-- which ever column we are grouping on that column should be in the select statement if we are 
-- not performing the aggregate functions on that column
select gender, AVG(age) from employee_demographics group by gender;
select * from employee_salary group by gender;

select occupation, salary from employee_salary group by occupation, salary; 
-- here grouping happens on unique combination of both the columns 

select gender, Avg(age), min(age), max(age), count(age) from employee_demographics group by gender;

---------------------------------------------------------------------
## ORDER BY
-- is use to sort the result set either in ascending or in descending order
select * from employee_demographics order by first_name DESC;

-- order by gender
select * from employee_demographics order by gender;
select * from employee_demographics order by gender, age desc; -- gender stays in ascending and age stays in desc order
select * from employee_demographics order by gender, age;-- first sorts the gender and sorts age according to gender
-- so order of the columns we write in the order by is very important
select * from employee_demographics order by age, gender; -- all values in the age are unique so 
-- its not possible to order gender depending on the sorted age values.

-- using column positions- not recommended
select * from employee_demographics order by 5, 4;

----------------------------------------------------------
# Having Vs WHERE

select gender, avg(age) from employee_demographics group by gender;

select gender, avg(age) from employee_demographics where avg(age) > 40 group by gender;
-- gives an error - Invalid use of group by function
-- the AVG(age) works only after the group by (gender) function groups all the rows of the gender column
-- so using WHERE clause on AVG(age) before group by gives error

select gender, avg(age) from employee_demographics group by gender  having avg(age) > 40 ;

select * from employee_salary;
select occupation, AVG(salary) from employee_salary group by occupation having avg(salary) > 50000;

select occupation, AVG(salary) 
from employee_salary 
 where occupation like '%manager%' -- row level filter with the WHERE clause
group by occupation
 having avg(salary) > 50000 -- filter at the aggregate function level
 ;
-- ** We have to use HAVING clause if we have to filter on the aggregated columns
-- _________________________________________________________________________

# Limit and Aliasing
-- Limit specifies how many rows do we need to have in the output
select * from employee_demographics limit 3;

select * from employee_demographics order by age desc limit 3;
SELECT 
    *
FROM
    employee_demographics
ORDER BY age DESC
LIMIT 2 , 1; -- results in 1 row after the 2nd row

# Aliasing
-- a way to change the name of the column

SELECT 
    gender, AVG(age) AS avg_age
FROM
    employee_demographics
GROUP BY gender
HAVING avg_age > 40;
-- _________________________________________________________________________

#JOINS
-- combines columns together
-- iNNER join = JOIN BY DEFAULT
-- outputs all the common rows of employee_id column of both the tables

Select * from 
employee_demographics ED
 JOIN
 employee_salary ES ON ED.employee_id = ES.employee_id;
-- *********************************************************
-- left join
Select * from 
employee_demographics ED
left JOIN
 employee_salary ES ON ED.employee_id = ES.employee_id;
-- *********************************************************
-- right join
SELECT 
    *
FROM
    employee_demographics ED
        RIGHT JOIN
    employee_salary ES ON ED.employee_id = ES.employee_id;
 -- *********************************************************   
--- SELF JOIN

Select * from 
employee_demographics ED
JOIN
employee_demographics demo; -- returns the dataset one row of a table to all the rows of the other table untill (no of rows)*(no of rows)

Select * from 
employee_demographics ED
JOIN
employee_demographics demo on ED.employee_id = demo.employee_id; -- returns the tables values added up to no of rows.

Select * from 
employee_demographics tb1
JOIN
employee_demographics tb2 on tb1.employee_id+1= tb2.employee_id; 

Select * from 
employee_salary tb1
JOIN
employee_salary tb2 on tb1.employee_id +1 = tb2.employee_id; 

-- JOINING MULTIPLE TABLES
-- here parks_departments is a reference table where there are no repeated rows
Select * from 
employee_demographics ED
 JOIN
 employee_salary ES ON ED.employee_id = ES.employee_id
 jOIN 
 parks_departments PD on ES.dept_id = PD.department_id;
 -- ____________________________________________________________________________
 #*******************************************************************
 #######*************UNIONS**************##########
 -- Unions allows us to combine the rows of differnet table or the same table.
 -- Union is by default UNION DISTINCT
 -- union all combines all the rows without distinct rows
 
 select first_name, last_name from employee_demographics where age > 40 and gender = 'Male'
Union all
select first_name, last_name from employee_salary where salary > 60000;

select first_name, last_name, 'Old Man' as label from employee_demographics where age > 40 and gender = 'Male'
Union
select first_name, last_name, 'Old Lady' as label from employee_demographics where age > 40 and gender = 'Female'
union
select first_name, last_name, 'Highly PAid Employees' as label from employee_salary where salary > 60000;
-- ____________________________________________________________________________
 #*******************************************************************
 #######*************String Functions**************##########
 -- length(str),upper(str), Lower(str),trim(str),ltrim(str),rtrim(str),
 -- left(str, no of characters), right(str,no of characters), 
 -- substring(str, position of character, no of characters), replace(str, char to be replaced, with character)
 -- locate('substr',str) - Locate position of substr in str
 -- concat(str, str, str)
select length('Hameeda'),  length(first_name), upper(first_name),lower(first_name),trim(first_name),
ltrim(first_name),rtrim(first_name), left(first_name,4), right(first_name,4), substring(first_name, 3,2),
replace(first_name,'a','b'), locate('e', first_name), concat(first_name,' ',last_name)
 from employee_demographics;
-- _______________________________________________________________________________
################ SubQuery####################
select first_name, employee_id from employee_demographics where employee_id
 in (select employee_id from employee_salary where salary > 70000);
 
 select first_name, salary, AVG(salary),
 (select avg(salary) from employee_salary) as avgsubquery from employee_salary 
 group by first_name, salary;
 
 select gender, avg(age), max(age), min(age), count(age) from 
 employee_demographics group by gender;
 
select * from (select gender, avg(age), max(age), min(age), count(age) from 
 employee_demographics group by gender) as avg_table; -- selecting form a table
 -- Every derived table must have an alias
 
 select gender, avg(`max(age)`) from (select gender, avg(age), max(age), min(age), count(age) from 
 employee_demographics group by gender) as avg_table; -- here selection for the column name max(age) so
 -- black tics are necessary to consider it as column name, which is a agg function on age in the subquery.

select gender, avg(avg_age) from 
(select gender,
 avg(age) as avg_age,
 max(age) as max_age, 
 min(age)as min_age, 
 count(age) as count_age from 
 employee_demographics group by gender) as avg_table
 group by gender; -- aliasing all the columns in the subquery

select avg(avg_age) from 
(select gender,
 avg(age) as avg_age,
 max(age) as max_age, 
 min(age)as min_age, 
 count(age) as count_age from 
 employee_demographics group by gender) as avg_table; -- now we have average of the column avg_age
-- _______________________________________________________________________________
################ Window Functions ####################
#### OVER(Partition by)

select gender, avg(age) over() from -- average age of everyone displayed for everyone
 employee_demographics;
 select first_name, avg(age) over(partition by first_name like 'A%') from 
 employee_demographics;
 
 select gender, avg(salary) avg_salary from 
 employee_demographics dem join employee_salary sal on dem.employee_id = sal.employee_id
 group by gender; -- group by returns the grouped avg of the aggegated column
 
select gender, avg(salary) over(partition by gender) avg_salary from -- avg salary of each gender partition
-- or dispalyed over the specific group 
 employee_demographics dem join employee_salary sal on dem.employee_id = sal.employee_id
 ; -- 

select dem.first_name, dem.last_name, gender, avg(salary) over(partition by gender) avg_salary from  
 employee_demographics dem join employee_salary sal on dem.employee_id = sal.employee_id
 ; -- no change in the column avg_salary

select dem.first_name, dem.last_name, gender, avg(salary) avg_salary from 
 employee_demographics dem join employee_salary sal on dem.employee_id = sal.employee_id
 group by dem.first_name, dem.last_name, gender; -- a complete different values of avg_salary column with GROUP BY

######## ROLLING TOTAL *********
select dem.first_name, dem.last_name, gender, salary,
sum(salary) over(partition by gender order by dem.first_name) Rolling_Total from -- gives the rolling total 
 employee_demographics dem join employee_salary sal on dem.employee_id = sal.employee_id
 ; 
 
 ######## ROW_NUMBER(),RANK(),DENSE_RANK() *********
 select dem.first_name, dem.last_name, gender, salary,
row_number() over(partition by gender order by salary desc) row_num,  -- numbers the rows irrespective of repetiton
rank()       over(partition by gender order by salary desc) rank_num, -- numbers same value for repeated values and skips the next numbers
dense_rank() over(partition by gender order by salary desc) dense_rank_num -- numbers same value for repeated values but doesn't skips the next numbers
from -- numbers the rows from -- numbers the rows
 employee_demographics dem join employee_salary sal on dem.employee_id = sal.employee_id
 ; 
-- ________________________________________________________________________________________
-- ***************** CTE - Common Table Expressions *********************
-- CTEs allowed us to define a sub query block that we can reference in a main query
-- format and standardized compared to subquery
-- Uses: to do more complex calculations which are not possible in one query and to 
-- increase the readability

 with CTE_example as 
 (
 select gender, avg(salary) avg_salary, max(salary) max_salary, min(salary)  min_salary,
 count(salary) cnt_salary from employee_demographics dem join employee_salary sal
 on dem.employee_id = sal.employee_id
 group by gender
 )
 select * from cte_example;
 
 with CTE_example as 
 (
 select gender, avg(salary) avg_salary, max(salary) max_salary, min(salary)  min_salary,
 count(salary) cnt_salary from employee_demographics dem join employee_salary sal
 on dem.employee_id = sal.employee_id
 group by gender
 )
 select avg(avg_salary) -- to do more complex calculations and increase readability
 from cte_example; 
 
  with CTE_example as 
 (
 select gender, avg(salary) avg_salary, max(salary) max_salary, min(salary)  min_salary,
 count(salary) cnt_salary from employee_demographics dem join employee_salary sal
 on dem.employee_id = sal.employee_id
 group by gender
 )
 select avg(avg_salary) -- to do more complex calculations and increase readability
 from cte_example; 
 
 select avg(max_salary) -- cannot be accessed outside the CTE  	 
 from cte_example; -- its just a common table, not saving anywhere
 
############ Mutiple CTEs############
 with CTE_example1 as 
 (
 select employee_id,gender, birth_date from employee_demographics
 where birth_date > '1985-01-01'
 ),
 CTE_example2 as 
 (
 select employee_id, salary from employee_salary
 where salary > 50000
 )
 select * from cte_example1 join cte_example2
 on cte_example1.employee_id = cte_example2.employee_id;
 
################### Renaming the columns of the CTE #########

 with CTE_example(Gender, AVG_sal, MAX_sal, MIN_Sal, CNT_Sal) as 
 (
 select gender, avg(salary) avg_salary, max(salary) max_salary, min(salary)  min_salary,
 count(salary) cnt_salary from employee_demographics dem join employee_salary sal
 on dem.employee_id = sal.employee_id
 group by gender
 )
 select * from cte_example;
-- _________________________________________________________________
-- ******************TEMP tables*****************************
-- Temporary tables are the tables only visible to the session they are created in 	
-- if temp table is created now and we exit from the SQL and it wont be there after login
-- mostly used to store the temporary data for intermediate results

create temporary table temp_table
(first_name varchar(50),
last_name varchar(50),
fav_movie varchar(100)
);
insert into temp_table values ('Hameeda', 'sk', 'Jurrasic');
select * from temp_table;

-- ############## another method to create a table

create temporary table temp_table_sal
select * from employee_salary where salary >= 70000;
select * from temp_table_sal;
-- _________________________________________________________________
-- ****************** STORED PROCEDURES *****************************
-- Stored procedures are the way to save the code and use over and over again
-- we need to call the stored procedure to execute that saved code
-- its a way to save the complex queries, simplifying repetitive code, enhancing the performance

##### Create a store procedure ###### not a best practice
create procedure large_salaries()
select * from employee_salary where salary >= 50000;

-- calling a SP
call large_salaries();

delimiter $$
create procedure large_salaries2()
begin
	select * from employee_salary where salary >= 50000;
	select * from employee_salary where salary = 10000; -- here ; is not the end of the stored procedure 
    -- thats what delimiter does
end $$
call large_salaries2()

delimiter $$
create procedure large_salaries3(eid_param int)
begin
	select salary from employee_salary where employee_id = eid_param; -- here ; is not the end of the stored procedure 
    -- thats what delimiter does
end $$
call large_salaries3(1);

-- _________________________________________________________________
-- ****************** EVENTS AND TRIGGERS *****************************
-- a TRIGGER is a block of code that executes automatically when an event takesplace on a specific table 
-- for example to enter data in demograhics when new data enters in to the salary table
--  some SQL databases like Microsoft SQL server have things like batch triggers or
--  table level triggers that'll only trigger once for all four of them. 

select * from employee_demographics;
select * from employee_salary;

Delimiter $$ 
create trigger employee_insert_2
	after insert on employee_salary
	for each row
begin
	insert into employee_demographics (employee_id, first_name, last_name)
    values (new.employee_id, new.first_name, new.last_name);
end $$
Delimiter ;
insert into employee_salary (employee_id, first_name, last_name, occupation, salary, dept_id) 
values(14, 'Hameedu', 'sk', 'data_Analyst', 100000,null);
-- delete from employee_salary where employee_id = 13;






































