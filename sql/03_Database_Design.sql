-- 03_Database_Design.sql
-- Oracle HR schema: constraints, foreign keys and column metadata

-- 1. Primary, foreign and unique constraints on the four main tables
SELECT
    a.table_name,
    a.constraint_name,
    a.constraint_type,
    a.status,
    a.r_constraint_name
FROM user_constraints a
WHERE a.table_name IN ('EMPLOYEES', 'DEPARTMENTS', 'JOBS', 'LOCATIONS')
  AND a.constraint_type IN ('P', 'R', 'U')
ORDER BY a.table_name, a.constraint_type;

------------------------------------------------------
-- 2. Columns used by each foreign key
SELECT
    c.table_name,
    c.constraint_name,
    cc.column_name,
    c.r_constraint_name
FROM user_constraints c
JOIN user_cons_columns cc
    ON c.constraint_name = cc.constraint_name
WHERE c.table_name IN ('EMPLOYEES', 'DEPARTMENTS', 'JOBS', 'LOCATIONS')
  AND c.constraint_type = 'R'
ORDER BY
    c.table_name,
    c.constraint_name,
    cc.position;

------------------------------------------------------
-- 3. Full relationships (child to parent) for EMPLOYEES and DEPARTMENTS
SELECT
    fk.table_name AS child_table,
    fkc.column_name AS child_column,
    pk.table_name AS parent_table,
    pkc.column_name AS parent_column,
    fk.constraint_name
FROM user_constraints fk
JOIN user_cons_columns fkc
    ON fk.constraint_name = fkc.constraint_name
   AND fk.table_name = fkc.table_name
JOIN user_constraints pk
    ON fk.r_constraint_name = pk.constraint_name
JOIN user_cons_columns pkc
    ON pk.constraint_name = pkc.constraint_name
   AND pk.table_name = pkc.table_name
   AND fkc.position = pkc.position
WHERE fk.constraint_type = 'R'
  AND fk.table_name IN ('EMPLOYEES', 'DEPARTMENTS')
ORDER BY
    fk.table_name,
    fk.constraint_name;

------------------------------------------------------
-- 4. Columns of the four main tables (used for the ER diagram)
SELECT
    table_name,
    column_id,
    column_name,
    data_type,
    nullable
FROM user_tab_columns
WHERE table_name IN (
    'EMPLOYEES',
    'DEPARTMENTS',
    'JOBS',
    'LOCATIONS'
)
ORDER BY table_name, column_id;

------------------------------------------------------
-- 5. All foreign keys in the schema
SELECT
    fk.constraint_name AS foreign_key,
    fk.table_name AS child_table,
    fkc.column_name AS child_column,
    pk.table_name AS parent_table,
    pkc.column_name AS parent_column
FROM user_constraints fk
JOIN user_cons_columns fkc
    ON fk.constraint_name = fkc.constraint_name
   AND fk.table_name = fkc.table_name
JOIN user_constraints pk
    ON fk.r_constraint_name = pk.constraint_name
JOIN user_cons_columns pkc
    ON pk.constraint_name = pkc.constraint_name
   AND pk.table_name = pkc.table_name
   AND pkc.position = fkc.position
WHERE fk.constraint_type = 'R'
ORDER BY fk.table_name, fk.constraint_name, fkc.position;

------------------------------------------------------
-- 6. Foreign key status (enabled, validated, delete rule)
SELECT
    table_name,
    constraint_name,
    status,
    validated,
    delete_rule
FROM user_constraints
WHERE constraint_type = 'R'
ORDER BY table_name, constraint_name;
