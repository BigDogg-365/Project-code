-- HAVING vs WHERE // LIMIT & Aliasing

SELECT gender, AVG(age) 
FROM parks_and_recreation.employee_demographics
# WHERE AVG(age) > 40          <- cannot filter bc GROUP BY hasn't occured
GROUP BY gender
;

SELECT gender, AVG(age) 
FROM parks_and_recreation.employee_demographics
GROUP BY gender
HAVING AVG(age) > 40
;

SELECT occupation, AVG(salary)
FROM parks_and_recreation.employee_salary
GROUP BY occupation
;

SELECT occupation, AVG(salary)
FROM parks_and_recreation.employee_salary
WHERE occupation LIKE '%manager%'
GROUP BY occupation
#HAVING AVG(salary) > 75000
;
#---- Limit -------
SELECT *
FROM parks_and_recreation.employee_demographics
ORDER BY age DESC
LIMIT 3				# only outputs first 3 rows
;

SELECT *
FROM parks_and_recreation.employee_demographics
ORDER BY age DESC
LIMIT 2, 1		# only outputs 1 row after 2nd row
;
# ----- Aliasing   (changing name of column)
SELECT gender, AVG(age) AS avg_age 		# 'AS' changes output column name to avg_age
FROM parks_and_recreation.employee_demographics
GROUP BY gender
HAVING avg_age >40	
;