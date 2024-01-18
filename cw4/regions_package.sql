CREATE SEQUENCE region_seq;

CREATE OR REPLACE PACKAGE REGIONS_PACKAGE IS
    FUNCTION get_region(p_region_id REGIONS.REGION_ID%TYPE) RETURN VARCHAR2;
    PROCEDURE create_region(p_region_name IN REGIONS.REGION_NAME%TYPE);
    PROCEDURE update_region(p_region_id IN REGIONS.REGION_ID%TYPE, p_region_name IN REGIONS.REGION_NAME%TYPE);
    PROCEDURE delete_region(p_region_id IN REGIONS.REGION_ID%TYPE);
END REGIONS_PACKAGE;


CREATE OR REPLACE PACKAGE BODY REGIONS_PACKAGE IS
    FUNCTION get_region(p_region_id REGIONS.REGION_ID%TYPE) RETURN VARCHAR2 IS
    v_name VARCHAR2(255);
    BEGIN
        SELECT region_name INTO v_name
        FROM regions
        WHERE region_id = p_region_id;
        RETURN v_name;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Brak regionu o takim ID. Kod błędu: ' || SQLCODE);
        RETURN NULL;
    END;

    -----------------------------------------------------------------------------

    PROCEDURE create_region(p_region_name IN REGIONS.REGION_NAME%TYPE) IS
    BEGIN
        INSERT INTO regions (region_id, region_name)
        VALUES (region_seq.NEXTVAL, p_region_name);
        DBMS_OUTPUT.PUT_LINE('Dodano region');
    END;

    -----------------------------------------------------------------------------

    PROCEDURE update_region(p_region_id IN REGIONS.REGION_ID%TYPE, p_region_name IN REGIONS.REGION_NAME%TYPE) IS
    BEGIN
        UPDATE regions
        SET region_name = p_region_name
        WHERE region_id = p_region_id;
        DBMS_OUTPUT.PUT_LINE('Zaktualizowano region');
    END;


    -----------------------------------------------------------------------------

    PROCEDURE delete_region(p_region_id IN REGIONS.REGION_ID%TYPE) IS
    BEGIN
        DELETE FROM regions
        WHERE region_id = p_region_id;
        DBMS_OUTPUT.PUT_LINE('Usunięto region');
    END;

END REGIONS_PACKAGE;
