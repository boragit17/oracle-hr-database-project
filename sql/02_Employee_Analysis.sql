-- 02_Employee_Analysis.sql
-- Oracle HR schema: analysis queries on employees, departments and salaries

-- 1. Employees per department (empty departments show 0)
SELECT
    d.department_id,
    d.department_name,
    COUNT(e.employee_id) AS total_employees
FROM departments d
LEFT JOIN employees e
    ON d.department_id = e.department_id
GROUP BY
    d.department_id,
    d.department_name
ORDER BY total_employees DESC;

----------------------------------------------
-- 2. Departments without employees
SELECT
    d.department_id,
    d.department_name
FROM departments d
LEFT JOIN employees e
    ON d.department_id = e.department_id
WHERE e.employee_id IS NULL
ORDER BY d.department_id;

----------------------------------------------
-- 3. Average salary per department
SELECT
    d.department_id,
    d.department_name,
    COUNT(e.employee_id) AS total_employees,
    ROUND(AVG(e.salary), 2) AS average_salary
FROM departments d
LEFT JOIN employees e
    ON d.department_id = e.department_id
GROUP BY
    d.department_id,
    d.department_name
ORDER BY average_salary DESC NULLS LAST;

----------------------------------------------
-- 4. Salary range per department (min, max, average)
SELECT
    d.department_id,
    d.department_name,
    COUNT(e.employee_id) AS total_employees,
    MIN(e.salary) AS minimum_salary,
    MAX(e.salary) AS maximum_salary,
    ROUND(AVG(e.salary), 2) AS average_salary
FROM departments d
LEFT JOIN employees e
    ON d.department_id = e.department_id
GROUP BY
    d.department_id,
    d.department_name
ORDER BY maximum_salary DESC NULLS LAST;

----------------------------------------------
-- 5. Departments with more than 5 employees (HAVING)
SELECT
    d.department_id,
    d.department_name,
    COUNT(e.employee_id) AS total_employees
FROM departments d
LEFT JOIN employees e
    ON d.department_id = e.department_id
GROUP BY
    d.department_id,
    d.department_name
HAVING COUNT(e.employee_id) > 5
ORDER BY total_employees DESC;

----------------------------------------------
-- 6. Employees earning more than the average salary (subquery)
SELECT
    employee_id,
    first_name,
    last_name,
    salary
FROM employees
WHERE salary > (
    SELECT AVG(salary)
    FROM employees
)
ORDER BY salary DESC;

----------------------------------------------
-- 7. Employees hired on or after 1 January 2000
SELECT
    employee_id,
    first_name,
    last_name,
    hire_date,
    job_id
FROM employees
WHERE hire_date >= DATE '2000-01-01'
ORDER BY hire_date DESC;

----------------------------------------------
-- 8. Employees and salaries by job
SELECT
    job_id,
    COUNT(*) AS total_employees,
    ROUND(AVG(salary), 2) AS average_salary,
    MIN(salary) AS minimum_salary,
    MAX(salary) AS maximum_salary
FROM employees
GROUP BY job_id
ORDER BY total_employees DESC;

----------------------------------------------
-- 9. Salary bands (CASE)
SELECT
    CASE
        WHEN salary < 4000 THEN 'Low Salary'
        WHEN salary < 8000 THEN 'Medium Salary'
        WHEN salary < 12000 THEN 'High Salary'
        ELSE 'Very High Salary'
    END AS salary_category,
    COUNT(*) AS total_employees
FROM employees
WHERE salary IS NOT NULL
GROUP BY
    CASE
        WHEN salary < 4000 THEN 'Low Salary'
        WHEN salary < 8000 THEN 'Medium Salary'
        WHEN salary < 12000 THEN 'High Salary'
        ELSE 'Very High Salary'
    END
ORDER BY total_employees DESC;

----------------------------------------------
-- 10. Orphan check: employees whose department does not exist
SELECT
    e.employee_id,
    e.first_name,
    e.last_name,
    e.department_id
FROM employees e
LEFT JOIN departments d
    ON e.department_id = d.department_id
WHERE e.department_id IS NOT NULL
  AND d.department_id IS NULL
ORDER BY e.employee_id;
