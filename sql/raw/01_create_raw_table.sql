-- Purpose: Raw layer table (loaded from ADF). 

IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'raw')
    EXEC('CREATE SCHEMA raw');
GO

IF OBJECT_ID('raw.simulated_hospital_admissions', 'U') IS NULL
BEGIN
    CREATE TABLE raw.simulated_hospital_admissions (
      Patient_ID INT NULL,
      Admission_Date DATE NULL,
      Discharge_Date DATE NULL,
      Age INT NULL,
      Age_Group VARCHAR(50) NULL,
      Gender VARCHAR(20) NULL,
      Condition_Type VARCHAR(100) NULL,
      Department VARCHAR(100) NULL,
      Severity_Score INT NULL,
      Length_of_Stay INT NULL,
      Insurance_Type VARCHAR(100) NULL,
      Discharge_Status VARCHAR(50) NULL,
      Readmission_Within_30_Days VARCHAR(10) NULL,
      Clinical_Notes VARCHAR(1000) NULL
    );
END;
GO
