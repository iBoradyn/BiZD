CREATE TABLE daily_exchange_summary (
    day DATE,
	code_id INT,
    avg_open DECIMAL,
    avg_close DECIMAL,
	avg_high DECIMAL,
    avg_low DECIMAL,
	total_volume DECIMAL
);

ALTER TABLE daily_exchange_summary
    ADD FOREIGN KEY(code_id) REFERENCES exchange_codes(id);

ALTER TABLE daily_exchange_summary
    ADD PRIMARY KEY (day, code_id);



CREATE OR REPLACE FUNCTION update_daily_summary() RETURNS TRIGGER AS $$
DECLARE
    v_day DATE;
	v_code_id INT;
BEGIN
    v_day := DATE(NEW.dateTime);
	v_code_id := NEW.code_id;
    IF EXISTS (SELECT 1 FROM daily_exchange_summary WHERE day = v_day AND code_id = v_code_id) THEN
        UPDATE daily_exchange_summary
        SET avg_open = (SELECT AVG(open) FROM exchange_history WHERE DATE(dateTime) = v_day AND code_id = v_code_id),
            avg_close = (SELECT AVG(close) FROM exchange_history WHERE DATE(dateTime) = v_day AND code_id = v_code_id),
			avg_high = (SELECT AVG(high) FROM exchange_history WHERE DATE(dateTime) = v_day AND code_id = v_code_id),
			avg_low = (SELECT AVG(low) FROM exchange_history WHERE DATE(dateTime) = v_day AND code_id = v_code_id),
			total_volume = (SELECT SUM(volume) FROM exchange_history WHERE DATE(dateTime) = v_day AND code_id = v_code_id)
        WHERE day = v_day AND code_id = v_code_id;
    ELSE
        INSERT INTO daily_exchange_summary(day, code_id, avg_open, avg_close, avg_high, avg_low, total_volume)
        VALUES (
			v_day, v_code_id,
			(SELECT AVG(open) FROM exchange_history WHERE DATE(dateTime) = v_day AND code_id = v_code_id),
		    (SELECT AVG(close) FROM exchange_history WHERE DATE(dateTime) = v_day AND code_id = v_code_id),
		    (SELECT AVG(high) FROM exchange_history WHERE DATE(dateTime) = v_day AND code_id = v_code_id),
			(SELECT AVG(low) FROM exchange_history WHERE DATE(dateTime) = v_day AND code_id = v_code_id),
			(SELECT SUM(volume) FROM exchange_history WHERE DATE(dateTime) = v_day AND code_id = v_code_id)
		   );
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER exchange_history_after_change
AFTER INSERT OR UPDATE OR DELETE ON exchange_history
FOR EACH ROW
EXECUTE FUNCTION update_daily_summary();

-- Anonimowa procedura do załadowania istniejących rekordów do posumowań dziennych
DO $$
DECLARE
    rec RECORD;
BEGIN
    FOR rec IN SELECT * FROM exchange_history LOOP
        UPDATE exchange_history
        SET open = rec.open, close = rec.close
        WHERE id = rec.id;
    END LOOP;
END;
$$;