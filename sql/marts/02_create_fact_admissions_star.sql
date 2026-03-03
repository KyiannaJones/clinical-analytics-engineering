-- Purpose: Star schema fact table referencing dimensions by surrogate key

IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'marts')
    EXEC('CREATE SCHEMA marts');
GO

IF OBJECT_ID('marts.fact_admissions_star', 'U') IS NOT NULL
    DROP TABLE marts.fact_admissions_star;
GO

CREATE TABLE marts.fact_admissions_star (
    Admission_ID VARCHAR(100) NOT NULL,
    Patient_Key INT NOT NULL,
    Department_Key INT NOT NULL,
    Condition_Key INT NOT NULL,
    Insurance_Key INT NOT NULL,
    Admission_Date DATE NULL,
    Discharge_Date DATE NULL,
    Length_of_Stay_Calc INT NULL,
    Severity_Score INT NULL,
    Discharge_Status VARCHAR(50) NULL,
    Readmission_Within_30_Days VARCHAR(10) NULL,

    CONSTRAINT PK_fact_admissions_star PRIMARY KEY (Admission_ID),
    CONSTRAINT FK_fact_patient FOREIGN KEY (Patient_Key) REFERENCES marts.dim_patient(Patient_Key),
    CONSTRAINT FK_fact_department FOREIGN KEY (Department_Key) REFERENCES marts.dim_department(Department_Key),
    CONSTRAINT FK_fact_condition FOREIGN KEY (Condition_Key) REFERENCES marts.dim_condition(Condition_Key),
    CONSTRAINT FK_fact_insurance FOREIGN KEY (Insurance_Key) REFERENCES marts.dim_insurance(Insurance_Key)
);
GO

INSERT INTO marts.fact_admissions_star (
    Admission_ID, Patient_Key, Department_Key, Condition_Key, Insurance_Key,
    Admission_Date, Discharge_Date, Length_of_Stay_Calc, Severity_Score,
    Discharge_Status, Readmission_Within_30_Days
)
SELECT
    s.Admission_ID,
    p.Patient_Key,
    d.Department_Key,
    c.Condition_Key,
    i.Insurance_Key,
    s.Admission_Date,
    s.Discharge_Date,
    DATEDIFF(DAY, s.Admission_Date, s.Discharge_Date) AS Length_of_Stay_Calc,
    s.Severity_Score,
    s.Discharge_Status,
    s.Readmission_Within_30_Days
FROM staging.vw_admissions s
JOIN marts.dim_patient p
    ON p.Patient_ID = s.Patient_ID
   AND (p.Age = s.Age OR (p.Age IS NULL AND s.Age IS NULL))
   AND (p.Age_Group = s.Age_Group OR (p.Age_Group IS NULL AND s.Age_Group IS NULL))
   AND (p.Gender = s.Gender OR (p.Gender IS NULL AND s.Gender IS NULL))
JOIN marts.dim_department d
    ON d.Department = s.Department
JOIN marts.dim_condition c
    ON c.Condition_Type = s.Condition_Type
JOIN marts.dim_insurance i
    ON i.Insurance_Type = s.Insurance_Type;
GO
