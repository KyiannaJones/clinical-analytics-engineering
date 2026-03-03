-- Purpose: Star schema dimensions

IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'marts')
    EXEC('CREATE SCHEMA marts');
GO

-- dim_department
IF OBJECT_ID('marts.dim_department', 'U') IS NOT NULL DROP TABLE marts.dim_department;
GO
CREATE TABLE marts.dim_department (
    Department_Key INT IDENTITY(1,1) PRIMARY KEY,
    Department VARCHAR(100) NOT NULL
);
GO
INSERT INTO marts.dim_department (Department)
SELECT DISTINCT Department
FROM staging.vw_admissions
ORDER BY Department;
GO

-- dim_condition
IF OBJECT_ID('marts.dim_condition', 'U') IS NOT NULL DROP TABLE marts.dim_condition;
GO
CREATE TABLE marts.dim_condition (
    Condition_Key INT IDENTITY(1,1) PRIMARY KEY,
    Condition_Type VARCHAR(100) NOT NULL
);
GO
INSERT INTO marts.dim_condition (Condition_Type)
SELECT DISTINCT Condition_Type
FROM staging.vw_admissions
ORDER BY Condition_Type;
GO

-- dim_insurance
IF OBJECT_ID('marts.dim_insurance', 'U') IS NOT NULL DROP TABLE marts.dim_insurance;
GO
CREATE TABLE marts.dim_insurance (
    Insurance_Key INT IDENTITY(1,1) PRIMARY KEY,
    Insurance_Type VARCHAR(100) NOT NULL
);
GO
INSERT INTO marts.dim_insurance (Insurance_Type)
SELECT DISTINCT Insurance_Type
FROM staging.vw_admissions
ORDER BY Insurance_Type;
GO

-- dim_patient
IF OBJECT_ID('marts.dim_patient', 'U') IS NOT NULL DROP TABLE marts.dim_patient;
GO
CREATE TABLE marts.dim_patient (
    Patient_Key INT IDENTITY(1,1) PRIMARY KEY,
    Patient_ID INT NOT NULL,
    Age INT NULL,
    Age_Group VARCHAR(50) NULL,
    Gender VARCHAR(20) NULL
);
GO
INSERT INTO marts.dim_patient (Patient_ID, Age, Age_Group, Gender)
SELECT DISTINCT Patient_ID, Age, Age_Group, Gender
FROM staging.vw_admissions
ORDER BY Patient_ID;
GO
