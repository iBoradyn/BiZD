set serveroutput on;

-- Zadanie 1 i 2
DECLARE
    max_number NUMBER;
    new_number NUMBER;
    new_departament_name DEPARTMENTS.DEPARTMENT_NAME%TYPE := 'EDUCATION';
    new_location_id NUMBER := 3000;
BEGIN
    SELECT MAX(DEPARTMENT_ID)
    INTO max_number
    FROM DEPARTMENTS;

    new_number := max_number + 10;

    INSERT INTO DEPARTMENTS (DEPARTMENT_ID, DEPARTMENT_NAME)
    VALUES (new_number, new_departament_name);

    UPDATE departments
    SET location_id = new_location_id
    WHERE department_id = new_number;
END;
-- SELECT * FROM DEPARTMENTS;

-- Zadanie 3
CREATE TABLE NOWA (
    WARTOSC VARCHAR(10)
);

DECLARE
BEGIN
    FOR i IN 1..10 LOOP
        IF i NOT IN (4, 6) THEN
            INSERT INTO NOWA(WARTOSC) VALUES (TO_CHAR(i));
        END IF;
    END LOOP;
END;
SELECT * FROM NOWA;

-- Zadanie 4
DECLARE
    v_country_row COUNTRIES%ROWTYPE;
BEGIN
    SELECT * INTO v_country_row
    FROM COUNTRIES
    WHERE COUNTRY_ID = 'CA';

    DBMS_OUTPUT.PUT_LINE('Nazwa kraju: ' || v_country_row.COUNTRY_NAME);
    DBMS_OUTPUT.PUT_LINE('ID regionu: ' || v_country_row.REGION_ID);
END;

-- Zadanie 5
DECLARE
    TYPE Departament_Info IS TABLE OF DEPARTMENTS.DEPARTMENT_NAME%TYPE INDEX BY PLS_INTEGER;
    v_departments Departament_Info;
BEGIN
    FOR i IN 1..10 LOOP
        SELECT department_name INTO v_departments(i)
        FROM departments
        WHERE department_id = i * 10;
    END LOOP;

    FOR i IN 1..10 LOOP
        DBMS_OUTPUT.PUT_LINE('Numer departamentu ' || i * 10 || ': ' || v_departments(i));
    END LOOP;
END;

-- Zadanie 6
DECLARE
    v_department DEPARTMENTS%ROWTYPE;
BEGIN
    FOR i IN 1..10 LOOP
        SELECT * INTO v_department
        FROM departments
        WHERE department_id = i * 10;

        DBMS_OUTPUT.PUT_LINE('ID departamentu: ' || v_department.DEPARTMENT_ID);
        DBMS_OUTPUT.PUT_LINE('Nazwa departamentu: ' || v_department.DEPARTMENT_NAME);
        DBMS_OUTPUT.PUT_LINE('ID menadżera: ' || v_department.MANAGER_ID);
        DBMS_OUTPUT.PUT_LINE('ID lokalizacji: ' || v_department.LOCATION_ID);
        DBMS_OUTPUT.NEW_LINE;
    END LOOP;
END;

-- Zadanie 7
DECLARE
    CURSOR salary_cursor IS
        SELECT e.salary, e.last_name
        FROM employees e
        WHERE e.department_id = 50;

    v_salary employees.salary%TYPE;
    v_last_name employees.last_name%TYPE;
BEGIN
    OPEN salary_cursor;
    LOOP
        FETCH salary_cursor INTO v_salary, v_last_name;
        EXIT WHEN salary_cursor%NOTFOUND;

        IF v_salary > 3100 THEN
            DBMS_OUTPUT.PUT_LINE(v_last_name || ' nie dawać podwyżki');
        ELSE
            DBMS_OUTPUT.PUT_LINE(v_last_name || ' dać podwyżkę');
        END IF;
    END LOOP;
    CLOSE salary_cursor;
END;

-- Zadanie 8
CREATE OR REPLACE PROCEDURE display_employees (
    p_min_salary IN employees.salary%TYPE,
    p_max_salary IN employees.salary%TYPE,
    p_name_part IN VARCHAR2
) IS
    CURSOR employee_cursor (c_min_salary employees.salary%TYPE, c_max_salary employees.salary%TYPE, c_name_part VARCHAR2) IS
        SELECT first_name, last_name, salary
        FROM employees
        WHERE salary BETWEEN c_min_salary AND c_max_salary
          AND LOWER(first_name) LIKE '%' || LOWER(c_name_part) || '%';

    v_first_name employees.first_name%TYPE;
    v_last_name employees.last_name%TYPE;
    v_salary employees.salary%TYPE;
BEGIN
    OPEN employee_cursor(p_min_salary, p_max_salary, p_name_part);
    LOOP
        FETCH employee_cursor INTO v_first_name, v_last_name, v_salary;
        EXIT WHEN employee_cursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(v_first_name || ' ' || v_last_name || ', Wynagrodzenie: ' || v_salary);
    END LOOP;
    CLOSE employee_cursor;
END;
/

BEGIN
    DBMS_OUTPUT.PUT_LINE('Pracownicy z widełkami 1000-5000 i częścią imienia "a":');
    display_employees(1000, 5000, 'a');

    DBMS_OUTPUT.PUT_LINE('Pracownicy z widełkami 5000-20000 i częścią imienia "u":');
    display_employees(5000, 20000, 'u');
END;
/

-- Zadanie 9
-- a
CREATE OR REPLACE PROCEDURE add_job (
    p_job_id IN jobs.job_id%TYPE,
    p_job_title IN jobs.job_title%TYPE
) AS
BEGIN
    INSERT INTO jobs (job_id, job_title)
    VALUES (p_job_id, p_job_title);
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Wystąpił wyjątek: ' || SQLERRM);
END;
/

-- b
CREATE OR REPLACE PROCEDURE modify_job_title (
    p_job_id IN jobs.job_id%TYPE,
    p_new_title IN jobs.job_title%TYPE
) AS
    v_rows_updated INT;
BEGIN
    UPDATE jobs
    SET job_title = p_new_title
    WHERE job_id = p_job_id;

    v_rows_updated := SQL%ROWCOUNT;

    IF v_rows_updated = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Nie zaktualizowano żadnych stanowisk pracy');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Wystąpił wyjątek: ' || SQLERRM);
END;
/

-- c
CREATE OR REPLACE PROCEDURE delete_job (
    p_job_id IN jobs.job_id%TYPE
) AS
    v_rows_deleted INT;
BEGIN
    DELETE FROM jobs
    WHERE job_id = p_job_id;

    v_rows_deleted := SQL%ROWCOUNT;

    IF v_rows_deleted = 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'Nie usunięto żadnych stanowisk pracy');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Wystąpił wyjątek: ' || SQLERRM);
END;
/

-- d
CREATE OR REPLACE PROCEDURE get_employee_salary (
    p_employee_id IN employees.employee_id%TYPE,
    o_salary OUT employees.salary%TYPE,
    o_last_name OUT employees.last_name%TYPE
) AS
BEGIN
    SELECT salary, last_name
    INTO o_salary, o_last_name
    FROM employees
    WHERE employee_id = p_employee_id;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Wystąpił wyjątek: ' || SQLERRM);
END;
/

-- e
SELECT MAX(employee_id) FROM employees; -- 206
CREATE SEQUENCE employee_seq
    START WITH 207
    INCREMENT BY 1;

CREATE OR REPLACE PROCEDURE add_employee (
    p_first_name IN employees.first_name%TYPE DEFAULT 'Jan',
    p_last_name IN employees.last_name%TYPE DEFAULT 'Kowalski',
    p_email IN employees.email%TYPE DEFAULT 'jkowalski@wp.pl',
    p_phone_number IN employees.phone_number%TYPE DEFAULT '123456789',
    p_hire_date IN employees.hire_date%TYPE DEFAULT SYSDATE,
    p_job_id IN employees.job_id%TYPE DEFAULT 20,
    p_salary IN employees.salary%TYPE DEFAULT 2000,
    p_commission_pct IN employees.commission_pct%TYPE DEFAULT NULL,
    p_manager_id IN employees.manager_id%TYPE DEFAULT NULL,
    p_department_id IN employees.department_id%TYPE DEFAULT NULL
) AS
BEGIN
    IF p_salary > 20000 THEN
        RAISE_APPLICATION_ERROR(-20003, 'Wynagrodzenie przekracza dopuszczalny limit 20000');
    END IF;

    INSERT INTO employees (
        employee_id, first_name, last_name, email, phone_number,
        hire_date, job_id, salary, commission_pct, manager_id, department_id
    )
    VALUES (
        employee_seq.NEXTVAL, p_first_name, p_last_name, p_email, p_phone_number,
        p_hire_date, p_job_id, p_salary, p_commission_pct, p_manager_id, p_department_id
    );
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Wystąpił wyjątek: ' || SQLERRM);
END;
/

-- testy
BEGIN
    -- a
    add_job(20, 'New Job');
    -- b
    add_job(21, 'New Job 2');
    modify_job_title(21, 'Modified Job');
    -- c
    add_job(22, 'New Job 2');
    delete_job(22);
END;
/

-- d
DECLARE
    v_salary employees.salary%TYPE;
    v_last_name employees.last_name%TYPE;
BEGIN
    get_employee_salary(104, v_salary, v_last_name);
    DBMS_OUTPUT.PUT_LINE('Nazwisko: ' || v_last_name || ', Wynagrodzenie: ' || v_salary);
END;
/

-- e
BEGIN
    add_employee();
END;
/
SELECT * FROM employees WHERE employees.employee_id > 207;

BEGIN
    add_employee(
        p_first_name => 'Anna',
        p_last_name => 'Nowak',
        p_email => 'anowak@email.com',
        p_job_id => 103,
        p_salary => 25000
    );
END;
/