CREATE TABLE Regions(
    region_id INT PRIMARY KEY, 
    region_name VARCHAR(45)
);

CREATE TABLE Countries(
    country_id INT PRIMARY KEY, 
    country_name VARCHAR(45),
    region_id INT,
    CONSTRAINT fk_region
        FOREIGN KEY(region_id) REFERENCES Regions(region_id) ON DELETE CASCADE
);

CREATE TABLE Locations(
    location_id INT PRIMARY KEY,
    street_address VARCHAR(45),
    postal_code VARCHAR(10),
    city VARCHAR(45),
    state_province VARCHAR(45),
    country_id INT,
    CONSTRAINT fk_country
        FOREIGN KEY(country_id) REFERENCES Countries(country_id) ON DELETE CASCADE
);

CREATE TABLE Departments(
    department_id INT PRIMARY KEY,
    department_name VARCHAR(45),
    manager_id INT,
    location_id INT
);

CREATE TABLE Job_History(
    employee_id INT,
    start_date DATE,
    end_date DATE,
    job_id INT,
    department_id INT
);

CREATE TABLE Jobs(
    job_id INT PRIMARY KEY,
    job_title VARCHAR(45),
    min_salary NUMBER(7,2),
    max_salary NUMBER(7,2),
    CONSTRAINT salary_check
        CHECK(max_salary-min_salary >= 2000)
);

CREATE TABLE Employees(
    employee_id INT PRIMARY KEY,
    first_name VARCHAR(45),
    last_name VARCHAR(45),
    email VARCHAR(45),
    phone_number VARCHAR(20),
    hire_date DATE,
    job_id INT,
    salary NUMBER(7,2),
    commission_pct NUMBER(3,2),
    manager_id INT,
    department_id INT
);

ALTER TABLE Employees ADD FOREIGN KEY(job_id) REFERENCES Jobs(job_id) ON DELETE CASCADE;
ALTER TABLE Employees ADD FOREIGN KEY(manager_id) REFERENCES Employees(employee_id) ON DELETE CASCADE;
ALTER TABLE Employees ADD FOREIGN KEY(department_id) REFERENCES Departments(department_id) ON DELETE CASCADE;
ALTER TABLE Job_History ADD PRIMARY KEY(employee_id, start_date);
ALTER TABLE Job_History ADD FOREIGN KEY(job_id) REFERENCES Jobs(job_id) ON DELETE CASCADE;
ALTER TABLE Job_History ADD FOREIGN KEY(department_id) REFERENCES Departments(department_id) ON DELETE CASCADE;
ALTER TABLE Departments ADD FOREIGN KEY (manager_id) REFERENCES Employees(employee_id) ON DELETE CASCADE;
ALTER TABLE Departments ADD FOREIGN KEY (location_id) REFERENCES Locations(location_id) ON DELETE CASCADE;

DROP TABLE Regions CASCADE CONSTRAINTS;
SELECT * FROM RECYCLEBIN;
FLASHBACK TABLE Regions TO BEFORE DROP;
ALTER TABLE Countries ADD FOREIGN KEY(region_id) REFERENCES Regions(region_id) ON DELETE CASCADE;