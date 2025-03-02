-- SubQueries

SELECT *
FROM employee_demographics
WHERE employee_id IN 
	(SELECT employee_id FROM employee_salary WHERE dept_id =1);
    
SELECT first_name, salary, AVG(salary)
FROM employee_salary
GROUP BY first_name, salary;		# Wanted AVG salary of all emp, but only get AVG of each row

SELECT first_name, salary, 
(SELECT AVG(salary) FROM employee_salary) AS Avg_Salary		# We get AVG of ALL salaries
FROM employee_salary;

SELECT gender, AVG(age), MAX(age), MIN(age), COUNT(age)
FROM employee_demographics
GROUP BY gender;

SELECT AVG(max_age), AVG (min_age)
FROM  
(SELECT gender, 
AVG(age) AS avg_age, 
MAX(age) AS max_age, 
MIN(age) AS min_age, 
COUNT(age)
FROM employee_demographics
GROUP BY gender)
AS Agg_Table;