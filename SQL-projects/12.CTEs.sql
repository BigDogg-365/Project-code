-- Common Table Expressions

WITH CTE_Example AS		# BEST PRACTICE
(
SELECT gender, AVG(salary) avg_sal, MAX(salary) max_sal, MIN(salary) min_sal, COUNT(salary) count_sal
FROM employee_demographics AS dem
JOIN employee_salary AS sal
	ON dem.employee_id = sal.employee_id
GROUP BY gender
)
SELECT AVG(avg_sal)
FROM CTE_Example
;

WITH CTE_Example (Gender, AVG_sal, MAX_sal, MIN_sal, COUNT_sal) AS			# Name Output Columns directly instead of alias within SELECT fields
(
SELECT gender, AVG(salary), MAX(salary), MIN(salary), COUNT(salary)
FROM employee_demographics AS dem
JOIN employee_salary AS sal
	ON dem.employee_id = sal.employee_id
GROUP BY gender
)
SELECT AVG(avg_sal)
FROM CTE_Example
;

SELECT AVG(avg_sal)				
FROM (SELECT gender, AVG(salary) avg_sal, MAX(salary) max_sal, MIN(salary) min_sal, COUNT(salary) count_sal
FROM employee_demographics AS dem
JOIN employee_salary AS sal							#USING SUB-QUERY not as professional
	ON dem.employee_id = sal.employee_id
GROUP BY gender
) example_subquery;

WITH CTE_Example AS		# 1st CTE
(
SELECT employee_id, gender, birth_date
FROM employee_demographics 
WHERE birth_date > '1985-01-01'
),
CTE_Example2 AS
(
SELECT Employee_id, salary
FROM employee_salary
WHERE salary > 50000
)
SELECT *
FROM CTE_Example
JOIN CTE_Example2
	ON CTE_Example.employee_id = CTE_Example2.employee_id
;