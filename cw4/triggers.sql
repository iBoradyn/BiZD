set serveroutput on;

-- Zadanie 1
CREATE TABLE archiwum_departamentow (
    id INT,
    nazwa VARCHAR2(50),
    data_zamkniecia DATE,
    ostatni_manager VARCHAR2(100)
);

CREATE OR REPLACE TRIGGER archive_departments
AFTER DELETE ON departments
FOR EACH ROW
BEGIN
    INSERT INTO archiwum_departamentow (id, nazwa, data_zamkniecia, ostatni_manager)
    VALUES (:OLD.department_id, :OLD.department_name, SYSDATE,
            (SELECT first_name || ' ' || last_name FROM employees WHERE employee_id = :OLD.manager_id));
END;
/

-- Zadanie 2
CREATE TABLE zlodziej (
    id INT PRIMARY KEY,
    user_name VARCHAR2(50),
    czas_zmiany DATE
);

CREATE SEQUENCE zlodziej_seq;

CREATE OR REPLACE TRIGGER check_salary_range
BEFORE INSERT OR UPDATE ON employees
FOR EACH ROW
BEGIN
    IF :NEW.salary < 2000 OR :NEW.salary > 26000 THEN
        RAISE_APPLICATION_ERROR(-20007, 'Wynagrodzenie poza dopuszczalnym zakresem');
    END IF;
END;
/

DECLARE
    v_user_name VARCHAR2(50) := USER;
BEGIN
    -- Test INSERT
    -- INSERT INTO employees (first_name, last_name, salary) VALUES ('Jan', 'Kowalski', 30000);
    -- Test UPDATE
    UPDATE employees SET salary = 30000 WHERE employee_id = 102;

    EXCEPTION WHEN OTHERS THEN
        INSERT INTO zlodziej (id, user_name, czas_zmiany)
        VALUES (zlodziej_seq.NEXTVAL, v_user_name, SYSDATE);
END;

SELECT * FROM zlodziej;

-- Zadanie 3
CREATE SEQUENCE employee_seq;

CREATE OR REPLACE TRIGGER auto_increment_employee
BEFORE INSERT ON employees
FOR EACH ROW
BEGIN
    IF :NEW.employee_id IS NULL THEN
        SELECT employee_seq.NEXTVAL INTO :NEW.employee_id FROM DUAL;
    END IF;
END;
/

-- Zadanie 4
CREATE OR REPLACE TRIGGER block_operations_on_job_grades
BEFORE INSERT OR UPDATE OR DELETE ON job_grades
BEGIN
    RAISE_APPLICATION_ERROR(-20008, 'Operacje na tabeli JOB_GRADES są zabronione');
END;
/

-- Zadanie 5
CREATE OR REPLACE TRIGGER keep_old_salary_values
BEFORE UPDATE OF min_salary, max_salary ON jobs
FOR EACH ROW
BEGIN
    :NEW.min_salary := :OLD.min_salary;
    :NEW.max_salary := :OLD.max_salary;
END;
/


-- Testy
-- Zadanie 1
DELETE FROM departments WHERE department_id = 290;
SELECT * FROM archiwum_departamentow;

-- Zadanie 3
INSERT INTO employees (first_name, last_name, email, hire_date, job_id) VALUES ('Jan', 'Kowalski', 'jkowalski@wp.pl', SYSDATE, 'PU_CLERK');
SELECT * FROM employees WHERE first_name = 'Jan' AND last_name = 'Kowalski';

-- Zadanie 4
INSERT INTO job_grades(grade, min_salary, max_salary) VALUES ('Z', 100, 200);
UPDATE job_grades SET min_salary = 1 WHERE grade = 'A';
DELETE FROM job_grades WHERE grade = 'A';

-- Zadanie 5
SELECT min_salary, max_salary FROM jobs WHERE job_id = 'FI_MGR'; -- 8200, 16000
UPDATE jobs SET min_salary = 1, max_salary = 2 WHERE job_id = 'FI_MGR';
SELECT min_salary, max_salary FROM jobs WHERE job_id = 'FI_MGR';
