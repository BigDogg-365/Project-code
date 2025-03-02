-- String Functions

SELECT LENGTH('skyfall');

SELECT first_name, LENGTH(first_name)
FROM employee_demographics
ORDER BY 2;

SELECT UPPER('sKy');
SELECT LOWER('sKy');

SELECT first_name, UPPER(first_name)
FROM employee_demographics;

SELECT TRIM('     Sky     ');
SELECT LTRIM('     Sky     ');
SELECT RTRIM('     Sky     ');

SELECT first_name, 
LEFT(first_name, 4),    #outputs first 4 LEFT char 
RIGHT(first_name, 4)    #outputs first 4 RIGHT char 
FROM employee_demographics;

SELECT first_name, 
LEFT(first_name, 4),    	#outputs first 4 LEFT char 
RIGHT(first_name, 4),   	#outputs first 4 RIGHT char 
SUBSTRING(first_name, 3,2),
birth_date,	#starting @ 3rd char, outputs 2 char()
SUBSTRING(birth_date, 6,2) AS birth_month
FROM employee_demographics;

SELECT first_name, REPLACE(first_name, 'a', 'Z')
FROM employee_demographics;

SELECT LOCATE('x', 'Alexander')		#finds location of selected char in supplied string
FROM employee_demographics;

SELECT first_name, LOCATE('an', first_name)		#finds location of selected char in supplied string
FROM employee_demographics;

SELECT first_name, last_name,
CONCAT(first_name,' ',last_name) AS full_name
FROM employee_demographics;