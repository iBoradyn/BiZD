-- Tabele do archiwizacji rekordów:

CREATE TABLE exchange_codes_archive(
    id INT GENERATED BY DEFAULT AS IDENTITY,
    code VARCHAR(50) UNIQUE
);
ALTER TABLE exchange_codes_archive
    ADD PRIMARY KEY(id);


CREATE TABLE exchange_history_archive(
    id INT GENERATED BY DEFAULT AS IDENTITY,
    code_id INT,
    dateTime TIMESTAMP,
    open DECIMAL,
    high DECIMAL,
    low DECIMAL,
    close DECIMAL,
    volume DECIMAL
);
ALTER TABLE exchange_history_archive
    ADD PRIMARY KEY(id);
ALTER TABLE exchange_history_archive
    ADD FOREIGN KEY(code_id) REFERENCES exchange_codes_archive(id);
------------------------------------------------------------------------------


-- a (Dodawanie, usuwanie, aktualizacja rekordów)
CREATE OR REPLACE PROCEDURE add_exchange_code(code_val VARCHAR(50)) AS $$
BEGIN
    INSERT INTO exchange_codes(code) VALUES(code_val);
    EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Error occurred: %', SQLERRM;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE PROCEDURE delete_exchange_code(code_id INT) AS $$
BEGIN
    DELETE FROM exchange_codes WHERE id = code_id;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE PROCEDURE delete_exchange_code(code_id INT) AS $$
BEGIN
    DELETE FROM exchange_codes WHERE id = code_id;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE PROCEDURE update_exchange_code(code_id INT, new_code VARCHAR(50)) AS $$
BEGIN
    UPDATE exchange_codes SET code = new_code WHERE id = code_id;
    EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Error occurred: %', SQLERRM;
END;
$$ LANGUAGE plpgsql;
-- -----------------------------------------------------------------------------

-- b (Archiwizacja usuniętych danych)

CREATE OR REPLACE FUNCTION archive_deleted_code() RETURNS TRIGGER AS $$
	BEGIN
		INSERT INTO exchange_codes_archive(id, code)
		VALUES (OLD.id, OLD.code);
		RETURN OLD;
    EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Error occurred: %', SQLERRM;
        RETURN NULL;
	END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE TRIGGER archive_before_delete_code
BEFORE DELETE ON exchange_codes
FOR EACH ROW EXECUTE FUNCTION archive_deleted_code();


CREATE OR REPLACE FUNCTION archive_deleted_history() RETURNS TRIGGER AS $$
	BEGIN
		INSERT INTO exchange_history_archive(id, code_id, dateTime, open, high, low, close, volume)
		VALUES (OLD.id, OLD.code_id, OLD.dateTime, OLD.open, OLD.high, OLD.low, OLD.close, OLD.volume);
		RETURN OLD;
    EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Error occurred: %', SQLERRM;
        RETURN NULL;
	END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE TRIGGER archive_before_delete_history
BEFORE DELETE ON exchange_history
FOR EACH ROW EXECUTE FUNCTION archive_deleted_history();


-- ----------------------------------------------------------------------------------

-- c (Logowanie informacji do tabeli)

CREATE TABLE activity_log (
    id INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    table_name VARCHAR(100),
    operation_type VARCHAR(50),
    operation_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    user_name VARCHAR(100)
);


CREATE OR REPLACE FUNCTION log_exchange_codes_and_history_operation() RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO activity_log(table_name, operation_type, user_name)
    VALUES (TG_TABLE_NAME::regclass::text, TG_OP, CURRENT_USER);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE TRIGGER exchange_codes_operation_trigger
AFTER INSERT OR DELETE OR UPDATE ON exchange_codes
FOR EACH ROW
EXECUTE FUNCTION log_exchange_codes_and_history_operation();


CREATE OR REPLACE TRIGGER exchange_history_operation_trigger
AFTER INSERT OR DELETE OR UPDATE ON exchange_history
FOR EACH ROW
EXECUTE FUNCTION log_exchange_codes_and_history_operation();

-- ----------------------------------------------------------------------------------
