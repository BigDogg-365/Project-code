-- Unions

SELECT * 
FROM parks_and_recreation.employee_demographics;

SELECT * 
FROM parks_and_recreation.employee_salary;

SELECT age, gender				# NOT A GOOD EXAMPLE bc Mixing Data types
FROM employee_demographics
UNION 
SELECT first_name, last_name 	# NOT A GOOD EXAMPLE bc Mixing Data types
FROM employee_salary;	

SELECT first_name, last_name
FROM employee_demographics
UNION 							# will only output DISTINCT results
SELECT first_name, last_name
FROM employee_salary;	

SELECT first_name, last_name
FROM employee_demographics
UNION ALL						# will output Duplicate results
SELECT first_name, last_name
FROM employee_salary;	

SELECT first_name, last_name, 'Old Man' AS Label
FROM employee_demographics
WHERE age > 40 AND gender = 'Male'
UNION
SELECT first_name, last_name, 'Old Lady' AS Label
FROM employee_demographics
WHERE age > 40 AND gender = 'Female'
UNION  							# 
SELECT first_name, last_name, 'High Paid Emp' AS Label
FROM employee_salary
WHERE salary > 70000
ORDER BY first_name, last_name
;