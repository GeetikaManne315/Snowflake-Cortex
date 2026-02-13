use database fraud_detection_db;
use schema hackathon;
-- Check the fraud probability distribution
SELECT 
    prediction,
    COUNT(*) as count
FROM fraud_predictions
GROUP BY prediction;
