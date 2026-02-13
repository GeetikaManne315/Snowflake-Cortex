use database fraud_detection_db;
use schema hackathon;

DROP SNOWFLAKE.ML.CLASSIFICATION IF EXISTS FRAUD_DETECTION_MODEL;

CREATE SNOWFLAKE.ML.CLASSIFICATION FRAUD_DETECTION_MODEL(
    INPUT_DATA => SYSTEM$REFERENCE('TABLE', 'fraud_train'),
    TARGET_COLNAME => 'CLASS',
    CONFIG_OBJECT => {'evaluate': TRUE}
);

CALL fraud_detection_model!SHOW_TRAINING_LOGS();

SHOW SNOWFLAKE.ML.CLASSIFICATION;

SELECT TIME, V1, V2, V3, V4, V5, V6, V7, V8, V9, V10,
       V11, V12, V13, V14, V15, V16, V17, V18, V19, V20,
       V21, V22, V23, V24, V25, V26, V27, V28, AMOUNT
FROM fraud_test 
WHERE CLASS = 1 
LIMIT 1;

SELECT FRAUD_DETECTION_MODEL!PREDICT(
    INPUT_DATA => OBJECT_CONSTRUCT(
        'TIME', 53727,
        'V1', -1.649278816,
        'V2', 1.263973556,
        'V3', -1.050825674,
        'V4', 2.237990639,
        'V5', -2.527889238,
        'V6', -0.8899399931,
        'V7', -2.355253671,
        'V8', 0.8546586412,
        'V9', -1.281242617,
        'V10', -2.705011382,
        'V11', 1.17447506,
        'V12', -4.381919567,
        'V13', -1.226665898,
        'V14', -2.953824253,
        'V15', 1.994161194,
        'V16', -3.30425391,
        'V17', -5.585794366,
        'V18', -1.643704032,
        'V19', 2.118633325,
        'V20', 0.08740636995,
        'V21', 0.6791764311,
        'V22', 0.7319070514,
        'V23', 0.3330454755,
        'V24', 0.392505236,
        'V25', -0.2741972975,
        'V26', 0.8023486675,
        'V27', 0.3908085528,
        'V28', 0.1121455315,
        'AMOUNT', 112.45
    )
) AS prediction;
