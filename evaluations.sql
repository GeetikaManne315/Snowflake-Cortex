use database fraud_detection_db;
use schema hackathon;

CREATE OR REPLACE TABLE fraud_predictions AS
SELECT 
    t.TIME, t.V1, t.V2, t.V3, t.V4, t.V5, t.V6, t.V7, t.V8, t.V9, t.V10,
    t.V11, t.V12, t.V13, t.V14, t.V15, t.V16, t.V17, t.V18, t.V19, t.V20,
    t.V21, t.V22, t.V23, t.V24, t.V25, t.V26, t.V27, t.V28, t.AMOUNT,
    t.CLASS as actual_class,
    FRAUD_DETECTION_MODEL!PREDICT(
        INPUT_DATA => OBJECT_CONSTRUCT(
            'TIME', t.TIME, 'V1', t.V1, 'V2', t.V2, 'V3', t.V3, 'V4', t.V4, 'V5', t.V5,
            'V6', t.V6, 'V7', t.V7, 'V8', t.V8, 'V9', t.V9, 'V10', t.V10,
            'V11', t.V11, 'V12', t.V12, 'V13', t.V13, 'V14', t.V14, 'V15', t.V15,
            'V16', t.V16, 'V17', t.V17, 'V18', t.V18, 'V19', t.V19, 'V20', t.V20,
            'V21', t.V21, 'V22', t.V22, 'V23', t.V23, 'V24', t.V24, 'V25', t.V25,
            'V26', t.V26, 'V27', t.V27, 'V28', t.V28, 'AMOUNT', t.AMOUNT
        )
    ) AS prediction
FROM fraud_test t;

SELECT 
    actual_class,
    prediction:"1"::FLOAT as fraud_probability,
    COUNT(*) as count
FROM fraud_predictions
GROUP BY actual_class, fraud_probability
ORDER BY actual_class, fraud_probability DESC
LIMIT 20;

SELECT 
    actual_class,
    CASE WHEN prediction:"1"::FLOAT > 0.5 THEN 1 ELSE 0 END as predicted_class,
    COUNT(*) as count
FROM fraud_predictions
GROUP BY actual_class, predicted_class
ORDER BY actual_class, predicted_class;

SELECT 
    actual_class,
    prediction:"class"::STRING as predicted_class,
    prediction:"probability":"1"::FLOAT as fraud_probability,
    COUNT(*) as count
FROM fraud_predictions
GROUP BY actual_class, predicted_class, fraud_probability
ORDER BY actual_class, fraud_probability DESC
LIMIT 20;

WITH metrics AS (
    SELECT 
        SUM(CASE WHEN actual_class = 1 AND prediction:"class"::STRING = '1' THEN 1 ELSE 0 END) as true_positives,
        SUM(CASE WHEN actual_class = 0 AND prediction:"class"::STRING = '0' THEN 1 ELSE 0 END) as true_negatives,
        SUM(CASE WHEN actual_class = 0 AND prediction:"class"::STRING = '1' THEN 1 ELSE 0 END) as false_positives,
        SUM(CASE WHEN actual_class = 1 AND prediction:"class"::STRING = '0' THEN 1 ELSE 0 END) as false_negatives
    FROM fraud_predictions
)
SELECT 
    true_positives,
    true_negatives,
    false_positives,
    false_negatives,
    ROUND((true_positives + true_negatives) * 100.0 / 
          (true_positives + true_negatives + false_positives + false_negatives), 2) as accuracy_percent,
    ROUND(true_positives * 100.0 / NULLIF(true_positives + false_positives, 0), 2) as precision_percent,
    ROUND(true_positives * 100.0 / NULLIF(true_positives + false_negatives, 0), 2) as recall_percent
FROM metrics;

WITH metrics1 AS (
    SELECT 
        SUM(CASE WHEN actual_class = 1 AND prediction:"class"::STRING = '1' THEN 1 ELSE 0 END) as true_positives,
        SUM(CASE WHEN actual_class = 0 AND prediction:"class"::STRING = '0' THEN 1 ELSE 0 END) as true_negatives,
        SUM(CASE WHEN actual_class = 0 AND prediction:"class"::STRING = '1' THEN 1 ELSE 0 END) as false_positives,
        SUM(CASE WHEN actual_class = 1 AND prediction:"class"::STRING = '0' THEN 1 ELSE 0 END) as false_negatives
    FROM fraud_predictions
)
SELECT 
    true_positives as caught_fraud,
    false_negatives as missed_fraud,
    false_positives as false_alarms,
    true_negatives as correct_legit,
    ROUND((true_positives + true_negatives) * 100.0 / 
          (true_positives + true_negatives + false_positives + false_negatives), 2) as accuracy_percent,
    ROUND(true_positives * 100.0 / NULLIF(true_positives + false_positives, 0), 2) as precision_percent,
    ROUND(true_positives * 100.0 / NULLIF(true_positives + false_negatives, 0), 2) as recall_percent
FROM metrics1;
