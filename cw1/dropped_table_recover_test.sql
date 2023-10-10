INSERT INTO JOBS(JOB_ID, JOB_TITLE, MIN_SALARY, MAX_SALARY) VALUES (1, 'Test', 3600, 7000);

SELECT * FROM JOBS;

DROP TABLE JOBS CASCADE CONSTRAINTS;

-- SELECT * FROM JOBS;  --SHOULD GIVE ERROR

FLASHBACK TABLE JOBS TO BEFORE DROP;

SELECT * FROM JOBS;

DELETE FROM JOBS WHERE JOB_ID=1;
