-- Purpose: Basic data quality checks

-- Row counts
SELECT COUNT(*) AS raw_count FROM raw.simulated_hospital_admissions;
SELECT COUNT(*) AS staging_count FROM staging.vw_admissions;
SELECT COUNT(*) AS fact_star_count FROM marts.fact_admissions_star;

-- Admission_ID uniqueness in staging
SELECT Admission_ID, COUNT(*) AS cnt
FROM staging.vw_admissions
GROUP BY Admission_ID
HAVING COUNT(*) > 1;

-- Null checks (critical fields)
SELECT COUNT(*) AS null_patient_id
FROM raw.simulated_hospital_admissions
WHERE Patient_ID IS NULL;

SELECT COUNT(*) AS null_admission_id
FROM staging.vw_admissions
WHERE Admission_ID IS NULL;
