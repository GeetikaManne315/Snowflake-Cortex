USE DATABASE fraud_detection_db;
USE SCHEMA hackathon;

CREATE OR REPLACE TABLE fraud_train AS
SELECT * FROM fraud_transactions
WHERE MOD(ABS(HASH(Time)), 10) < 8;

CREATE OR REPLACE TABLE fraud_test AS
SELECT * FROM fraud_transactions
WHERE MOD(ABS(HASH(Time)), 10) >= 8;

SELECT 'Training Set' as dataset, COUNT(*) as records FROM fraud_train
UNION ALL
SELECT 'Test Set' as dataset, COUNT(*) as records FROM fraud_test;

select count(*) from fraud_train;

select count(*) from fraud_test;
