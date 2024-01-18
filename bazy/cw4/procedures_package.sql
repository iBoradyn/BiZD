CREATE OR REPLACE PACKAGE PROCEDURE_PACKAGE IS
    PROCEDURE test_get_job_title(p_job_id IN jobs.job_id%TYPE);
    PROCEDURE test_calculate_annual_salary(p_employee_id IN employees.employee_id%TYPE);
    PROCEDURE test_format_phone_number(p_employee_id IN employees.employee_id%TYPE);
    PROCEDURE test_capitalize_first_last(p_string IN VARCHAR2);
    PROCEDURE test_pesel_to_birthdate(p_pesel IN VARCHAR2);
    PROCEDURE test_count_employees_departments(p_country_name IN VARCHAR2);
END PROCEDURE_PACKAGE;

CREATE OR REPLACE PACKAGE BODY PROCEDURE_PACKAGE IS
    PROCEDURE test_get_job_title(p_job_id IN jobs.job_id%TYPE) IS
    v_job_title jobs.job_title%TYPE;
    BEGIN
        v_job_title := get_job_title('PU_MAN');
        DBMS_OUTPUT.PUT_LINE('Nazwa pracy: ' || v_job_title);
        v_job_title := get_job_title(p_job_id);
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Wystąpił wyjątek: ' || SQLERRM);
    END;

    PROCEDURE test_calculate_annual_salary(p_employee_id IN employees.employee_id%TYPE) IS
    v_annual_salary NUMBER;
    BEGIN
        v_annual_salary := calculate_annual_salary(p_employee_id);
        DBMS_OUTPUT.PUT_LINE('Roczne zarobki: ' || v_annual_salary);
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Wystąpił wyjątek: ' || SQLERRM);
    END;

    PROCEDURE test_format_phone_number(p_employee_id IN employees.employee_id%TYPE) IS
    v_phone_number VARCHAR2(20);
    v_formatted_phone VARCHAR2(20);
    BEGIN
        SELECT e.phone_number INTO v_phone_number
        FROM employees e
        WHERE e.employee_id = p_employee_id;

        v_formatted_phone := FUNCTIONS_PACKAGE.format_phone_number(v_phone_number);
        DBMS_OUTPUT.PUT_LINE('Sformatowany numer: ' || v_formatted_phone);
    END;

    PROCEDURE test_capitalize_first_last(p_string IN VARCHAR2) IS
    v_capitalized_string VARCHAR2(100);
    BEGIN
        v_capitalized_string := capitalize_first_last(p_string);
        DBMS_OUTPUT.PUT_LINE('Zmodyfikowany ciąg: ' || v_capitalized_string);
    END;

    PROCEDURE test_pesel_to_birthdate(p_pesel IN VARCHAR2) IS
    v_birthdate DATE;
    BEGIN
        v_birthdate := pesel_to_birthdate(p_pesel);
        DBMS_OUTPUT.PUT_LINE('Data urodzenia: ' || TO_CHAR(v_birthdate, 'YYYY-MM-DD'));
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Wystąpił wyjątek: ' || SQLERRM);
    END;

    PROCEDURE test_count_employees_departments(p_country_name IN VARCHAR2) IS
    v_count_info VARCHAR2(100);
    BEGIN
        v_count_info := count_employees_departments(p_country_name);
        DBMS_OUTPUT.PUT_LINE(v_count_info);
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Wystąpił wyjątek: ' || SQLERRM);
    END;

END PROCEDURE_PACKAGE;