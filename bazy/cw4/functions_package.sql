CREATE OR REPLACE PACKAGE FUNCTIONS_PACKAGE IS
    FUNCTION get_job_title(p_job_id IN jobs.job_id%TYPE) RETURN jobs.job_title%TYPE;
    FUNCTION calculate_annual_salary(p_employee_id IN employees.employee_id%TYPE) RETURN NUMBER;
    FUNCTION format_phone_number(p_phone_number IN VARCHAR2) RETURN VARCHAR2;
    FUNCTION capitalize_first_last(p_string IN VARCHAR2) RETURN VARCHAR2;
    FUNCTION pesel_to_birthdate(p_pesel IN VARCHAR2) RETURN DATE;
    FUNCTION count_employees_departments(p_country_name IN VARCHAR2) RETURN VARCHAR2;
END FUNCTIONS_PACKAGE;

CREATE OR REPLACE PACKAGE BODY FUNCTIONS_PACKAGE IS

    FUNCTION get_job_title (p_job_id IN jobs.job_id%TYPE)
    RETURN jobs.job_title%TYPE AS
        v_job_title jobs.job_title%TYPE;
    BEGIN
        SELECT job_title INTO v_job_title FROM jobs WHERE job_id = p_job_id;
        RETURN v_job_title;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20004, 'Nie znaleziono pracy o podanym ID');
    END;

    FUNCTION calculate_annual_salary (p_employee_id IN employees.employee_id%TYPE)
    RETURN NUMBER AS
        v_annual_salary NUMBER;
    BEGIN
        SELECT (salary * 12) + (salary * NVL(commission_pct, 0))
        INTO v_annual_salary
        FROM employees
        WHERE employee_id = p_employee_id;

        RETURN v_annual_salary;
    END;

    FUNCTION format_phone_number (p_phone_number IN VARCHAR2)
    RETURN VARCHAR2 AS
    BEGIN
        RETURN '(' || SUBSTR(p_phone_number, 1, INSTR(p_phone_number, '.') - 1) || ')' || SUBSTR(p_phone_number, INSTR(p_phone_number, '.'));
    END;

    FUNCTION capitalize_first_last (p_string IN VARCHAR2)
    RETURN VARCHAR2 AS
    BEGIN
        RETURN UPPER(SUBSTR(p_string, 1, 1)) || LOWER(SUBSTR(p_string, 2, LENGTH(p_string) - 2)) || UPPER(SUBSTR(p_string, -1));
    END;

    FUNCTION pesel_to_birthdate (p_pesel IN VARCHAR2)
    RETURN DATE AS
        v_year VARCHAR2(4);
        v_month VARCHAR2(2);
        v_day VARCHAR2(2);
    BEGIN
        -- Działa tylko dla osób urodzonych w XX wieku
        v_year := '19' || SUBSTR(p_pesel, 1, 2);
        v_month := SUBSTR(p_pesel, 3, 2);
        v_day := SUBSTR(p_pesel, 5, 2);
        RETURN TO_DATE(v_year || '-' || v_month || '-' || v_day, 'YYYY-MM-DD');
    END;

    FUNCTION count_employees_departments (p_country_name IN VARCHAR2)
    RETURN VARCHAR2 AS
        v_employee_count INT;
        v_department_count INT;
        v_country_count INT;
    BEGIN
        SELECT COUNT(c.country_id) INTO v_country_count
        FROM countries c
        WHERE c.country_name = p_country_name;

        IF v_country_count = 0 THEN
            RAISE_APPLICATION_ERROR(-20006, 'Nie znaleziono kraju o podanej nazwie');
        END IF;

        SELECT COUNT(e.employee_id) INTO v_employee_count
        FROM employees e
        JOIN departments d ON e.department_id = d.department_id
        JOIN locations l ON d.location_id = l.location_id
        JOIN countries c ON l.country_id = c.country_id
        WHERE c.country_name = p_country_name;

        SELECT COUNT(DISTINCT d.department_id) INTO v_department_count
        FROM departments d
        JOIN locations l ON d.location_id = l.location_id
        JOIN countries c ON l.country_id = c.country_id
        WHERE c.country_name = p_country_name;

        RETURN 'Pracownicy: ' || v_employee_count || ', Departamenty: ' || v_department_count;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20006, 'Nie znaleziono kraju o podanej nazwie');
    END;

END FUNCTIONS_PACKAGE;