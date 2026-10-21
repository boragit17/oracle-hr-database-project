-- 01_Database_Exploration.sql
-- Oracle HR schema: table structure, row counts and a first join

-- 1. Table structure
SELECT
    table_name,
    column_id,
    column_name,
    data_type,
    data_length,
    nullable
FROM user_tab_columns
WHERE table_name IN ('EMPLOYEES', 'DEPARTMENTS')
ORDER BY table_name, column_id;

----------------------------------------------------------
-- 2. Row count per table
SELECT 'EMPLOYEES' AS table_name, COUNT(*) AS total_rows
FROM employees
UNION ALL
SELECT 'DEPARTMENTS', COUNT(*)
FROM departments;

----------------------------------------------------------
-- 3. Relationship between employees and departments
SELECT
    e.employee_id,
    e.first_name,
    e.last_name,
    e.department_id,
    d.department_name
FROM employees e
LEFT JOIN departments d
    ON e.department_id = d.department_id
ORDER BY e.employee_id;

----------------------------------------------------------
-- 4. Employees per department (empty departments show 0)
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
