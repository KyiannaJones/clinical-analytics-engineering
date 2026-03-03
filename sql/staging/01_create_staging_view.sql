-- Purpose: Staging layer view (clean + derived fields).
-- Admission_ID is a deterministic "fictitious" key since the dataset does not have an Encounter/Admission ID.

IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'staging')
    EXEC('CREATE SCHEMA staging');
GO

CREATE OR ALTER VIEW staging.vw_admissions AS
SELECT
    Patient_ID,
    Admission_Date,
    Discharge_Date,
    Age,
    Age_Group,
    Gender,
    Condition_Type,
    Department,
    Severity_Score,
    Length_of_Stay,
    Insurance_Type,
    Discharge_Status,
    Readmission_Within_30_Days,
    Clinical_Notes,

    CONCAT(
        CAST(Patient_ID AS varchar(20)), '-',
        CONVERT(char(8), Admission_Date, 112), '-',
        REPLACE(REPLACE(REPLACE(LOWER(Department), ' ', ''), '/', ''), '-', '')
    ) AS Admission_ID
FROM raw.simulated_hospital_admissions;
GO
