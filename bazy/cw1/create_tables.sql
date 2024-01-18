CREATE TABLE jobs(
    job_id INT,
    job_title VARCHAR(50),
    min_salary DECIMAL(10,2),
    max_salary DECIMAL(10,2),
    CHECK(max_salary-min_salary>=2000)
);
ALTER TABLE jobs
    ADD PRIMARY KEY(job_id);



CREATE TABLE employees(
    employee_id INT,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(50),
    phone_number VARCHAR(50),
    hire_date DATE,
    job_id INT,
    salary DECIMAL(10,2),
    commision_pct VARCHAR(50),
    manager_id INT,
    department_id INT
);
ALTER TABLE employees
    ADD PRIMARY KEY(employee_id);
ALTER TABLE employees
    ADD FOREIGN KEY(job_id) REFERENCES jobs(job_id);
ALTER TABLE employees
    ADD FOREIGN KEY(manager_id) REFERENCES employees(employee_id);



CREATE TABLE regions(
    region_id INT,
    region_name VARCHAR(50)
);
ALTER TABLE regions
    ADD PRIMARY KEY(region_id);



CREATE TABLE countries(
    country_id INT,
    country_name VARCHAR(50),
    region_id INT
);
ALTER TABLE countries
    ADD PRIMARY KEY(country_id);
ALTER TABLE countries
    ADD FOREIGN KEY(region_id) REFERENCES regions(region_id);



CREATE TABLE locations(
    location_id INT,
    street_address VARCHAR(50),
    postal_code VARCHAR(50),
    city VARCHAR(50),
    state_province VARCHAR(50),
    country_id INT
);
ALTER TABLE locations
    ADD PRIMARY KEY(location_id);
ALTER TABLE locations
    ADD FOREIGN KEY(country_id) REFERENCES countries(country_id);



CREATE TABLE departments(
    department_id INT,
    department_name VARCHAR(50),
    manager_id INT,
    location_id INT
);
ALTER TABLE departments
    ADD PRIMARY KEY(department_id);
ALTER TABLE departments
    ADD FOREIGN KEY(location_id) REFERENCES locations(location_id);
ALTER TABLE departments
    ADD FOREIGN KEY(manager_id) REFERENCES employees(employee_id);
ALTER TABLE employees
    ADD FOREIGN KEY(department_id) REFERENCES departments(department_id);



CREATE TABLE job_history(
    employee_id INT,
    start_date DATE,
    end_date DATE,
    job_id INT,
    department_id INT
);
ALTER TABLE job_history
    ADD FOREIGN KEY(employee_id) REFERENCES employees(employee_id);
ALTER TABLE job_history
    ADD FOREIGN KEY(job_id) REFERENCES jobs(job_id);
ALTER TABLE job_history
    ADD FOREIGN KEY(department_id) REFERENCES departments(department_id);
