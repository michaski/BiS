CREATE TABLE countries AS SELECT * FROM HR.countries;
CREATE TABLE departments AS SELECT * FROM HR.departments;
CREATE TABLE employees AS SELECT * FROM HR.employees;
CREATE TABLE job_grades AS SELECT * FROM HR.job_grades;
CREATE TABLE job_history AS SELECT * FROM HR.job_history;
CREATE TABLE jobs AS SELECT * FROM HR.jobs;
CREATE TABLE locations AS SELECT * FROM HR.locations;
CREATE TABLE regions AS SELECT * FROM HR.regions;

ALTER TABLE regions ADD PRIMARY KEY(region_id);
ALTER TABLE locations ADD PRIMARY KEY(location_id);
ALTER TABLE jobs ADD PRIMARY KEY(job_id);
ALTER TABLE job_history ADD PRIMARY KEY(employee_id, start_date);
ALTER TABLE job_grades ADD PRIMARY KEY(grade);
ALTER TABLE employees ADD PRIMARY KEY(employee_id);
ALTER TABLE departments ADD PRIMARY KEY(department_id);
ALTER TABLE countries ADD PRIMARY KEY(country_id);

ALTER TABLE countries ADD FOREIGN KEY(region_id) REFERENCES regions(region_id) ON DELETE CASCADE;
ALTER TABLE locations ADD FOREIGN KEY(country_id) REFERENCES countries(country_id) ON DELETE CASCADE;
ALTER TABLE departments ADD FOREIGN KEY(location_id) REFERENCES locations(location_id) ON DELETE CASCADE;
ALTER TABLE departments ADD FOREIGN KEY(manager_id) REFERENCES employees(employee_id) ON DELETE CASCADE;
ALTER TABLE employees ADD FOREIGN KEY(manager_id) REFERENCES employees(employee_id) ON DELETE CASCADE;
ALTER TABLE employees ADD FOREIGN KEY(department_id) REFERENCES departments(department_id) ON DELETE CASCADE;
ALTER TABLE employees ADD FOREIGN KEY(job_id) REFERENCES jobs(job_id) ON DELETE CASCADE;
ALTER TABLE job_history ADD FOREIGN KEY(job_id) REFERENCES jobs(job_id) ON DELETE CASCADE;
ALTER TABLE job_history ADD FOREIGN KEY(department_id) REFERENCES departments(department_id) ON DELETE CASCADE;

/* 1 */
SELECT CONCAT(CONCAT(last_name, ' '), salary) AS Wynagrodzenie FROM employees 
    WHERE department_id = 20 OR department_id = 50
        AND salary BETWEEN 2000 AND 7000
    ORDER BY last_name;

/* 2 */
SELECT hire_date, last_name, & AS user_col FROM employees
    WHERE manager_id IS NOT NULL
        AND EXTRACT(year FROM hire_date) = 2005
    ORDER BY user_col;

/* 3 */
SELECT CONCAT(CONCAT(first_name, ' '), last_name) AS name, salary, phone_number FROM employees
    WHERE INSTR(last_name, 'e', 3, 1) = 3
        AND INSTR(first_name, '&name_part', 1, 1) != 0
    ORDER BY name DESC;

/* 4 */
SELECT first_name, last_name, work_time, 
    CASE 
        WHEN work_time < 150 THEN ROUND(0.1 * salary, 2)
        WHEN work_time BETWEEN 150 AND 199 THEN ROUND(0.2 * salary, 2)
        WHEN work_time >= 200 THEN ROUND(0.3 * salary, 2)
    END AS wysokosc_dodatku
    FROM (SELECT first_name, last_name, ROUND(MONTHS_BETWEEN(SYSDATE, hire_date), 0) AS work_time, salary FROM employees)
    ORDER BY work_time;

/* 5 */
SELECT departments.department_name, SUM(salary) AS suma, ROUND(AVG(salary), 0) AS srednia
    FROM employees e1 JOIN departments on e1.department_id = departments.department_id
    WHERE 5000 < (SELECT MIN(salary) 
                    FROM employees e2 JOIN departments on e2.department_id = departments.department_id 
                    WHERE e1.department_id = e2.department_id)
    GROUP BY departments.department_name;
    
/* 6 */
SELECT employees.last_name, employees.department_id, departments.department_name, employees.job_id
    FROM employees JOIN departments on employees.department_id = departments.department_id
        JOIN locations on departments.location_id = locations.location_id
    WHERE locations.city = 'Toronto';

/* 7 */
SELECT e1.first_name, e1.last_name, e2.first_name, e2.last_name
    FROM employees e1 JOIN employees e2 on e1.department_id = e2.department_id
    WHERE e1.first_name = 'Jennifer' AND e1.first_name != e2.first_name AND e1.last_name != e2.last_name
    ORDER BY e1.employee_id;

/* 8 */
SELECT DISTINCT d1.department_id, d1.department_name
    FROM departments d1
    WHERE (SELECT COUNT(department_id) FROM employees WHERE department_id = d1.department_id) = 0;

/* 10 */
SELECT e1.first_name, e1.last_name, e1.job_id, departments.department_name, e1.salary, (SELECT grade FROM job_grades WHERE e1.salary BETWEEN min_salary AND max_salary) AS grade
    FROM employees e1 JOIN departments ON e1.department_id = departments.department_id;

/* 11 */
SELECT first_name, last_name
    FROM employees
    WHERE salary > (SELECT AVG(salary) FROM employees)
    ORDER BY salary;

/* 12 */
SELECT employee_id, first_name, last_name
    FROM employees e1
    WHERE 0 < (SELECT COUNT(employee_id) FROM employees WHERE department_id = e1.department_id AND last_name LIKE '%u%');