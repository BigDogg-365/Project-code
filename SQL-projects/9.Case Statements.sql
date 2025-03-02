-- CASE statements

SELECT first_name, last_name, age,
CASE
	WHEN age  <= 30 THEN 'Young'
    WHEN age  BETWEEN 30 and 50 THEN 'Old'
    WHEN age  > 50 THEN 'RIP'
END AS Age_Bracket
FROM employee_demographics;

-- Pay Increase & Bonus
-- < 50K = 5%
-- > 50K = 7%
-- Finance = 10% bonus

SELECT first_name, last_name, salary,
CASE
	WHEN salary < 50000 THEN salary + (salary * 0.05)
    WHEN salary > 50000 THEN salary + (salary * 0.07)
END AS New_Salary,
CASE
	WHEN dept_id = 6 THEN salary * 0.1
END AS Bonus
FROM employee_salary;