-- SELECT TABLE_NAME FROM ALL_TABLES WHERE OWNER='HR';

CREATE TABLE DEPARTMENTS AS (SELECT * FROM HR.DEPARTMENTS);
CREATE TABLE EMPLOYEES AS (SELECT * FROM HR.EMPLOYEES);
CREATE TABLE JOBS AS (SELECT * FROM HR.JOBS);
CREATE TABLE JOB_GRADES AS (SELECT * FROM HR.JOB_GRADES);
CREATE TABLE JOB_HISTORY AS (SELECT * FROM HR.JOB_HISTORY);
CREATE TABLE LOCATIONS AS (SELECT * FROM HR.LOCATIONS);
CREATE TABLE REGIONS  AS (SELECT * FROM HR.REGIONS);
CREATE TABLE COUNTRIES AS (SELECT * FROM HR.COUNTRIES);



ALTER TABLE jobs
    ADD PRIMARY KEY(job_id);

ALTER TABLE employees
    ADD PRIMARY KEY(employee_id);
ALTER TABLE employees
    ADD FOREIGN KEY(job_id) REFERENCES jobs(job_id);
ALTER TABLE employees
    ADD FOREIGN KEY(manager_id) REFERENCES employees(employee_id);

ALTER TABLE regions
    ADD PRIMARY KEY(region_id);

ALTER TABLE countries
    ADD PRIMARY KEY(country_id);
ALTER TABLE countries
    ADD FOREIGN KEY(region_id) REFERENCES regions(region_id);

ALTER TABLE locations
    ADD PRIMARY KEY(location_id);
ALTER TABLE locations
    ADD FOREIGN KEY(country_id) REFERENCES countries(country_id);

ALTER TABLE departments
    ADD PRIMARY KEY(department_id);
ALTER TABLE departments
    ADD FOREIGN KEY(location_id) REFERENCES locations(location_id);
ALTER TABLE departments
    ADD FOREIGN KEY(manager_id) REFERENCES employees(employee_id);
ALTER TABLE employees
    ADD FOREIGN KEY(department_id) REFERENCES departments(department_id);

ALTER TABLE job_history
    ADD FOREIGN KEY(employee_id) REFERENCES employees(employee_id);
ALTER TABLE job_history
    ADD FOREIGN KEY(job_id) REFERENCES jobs(job_id);
ALTER TABLE job_history
    ADD FOREIGN KEY(department_id) REFERENCES departments(department_id);
