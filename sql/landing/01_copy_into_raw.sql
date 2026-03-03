-- 01_copy_into_raw.sql
-- Purpose: Load landing CSV into raw schema
-- NOTE: SAS token intentionally not stored in Git

-- 1) Create credential (placeholder only)
IF NOT EXISTS (
    SELECT 1 
    FROM sys.database_scoped_credentials 
    WHERE name = 'blob_sas_credential'
)
BEGIN
    CREATE DATABASE SCOPED CREDENTIAL blob_sas_credential
    WITH IDENTITY = 'SHARED ACCESS SIGNATURE',
    SECRET = '***PASTE_SAS_TOKEN_LOCALLY_ONLY***';
END
GO

-- 2) External data source
IF NOT EXISTS (
    SELECT 1 
    FROM sys.external_data_sources 
    WHERE name = 'clinical_blob_landing'
)
BEGIN
    CREATE EXTERNAL DATA SOURCE clinical_blob_landing
    WITH (
        TYPE = BLOB_STORAGE,
        LOCATION = 'https://<your-storage-account>.blob.core.windows.net/landing',
        CREDENTIAL = blob_sas_credential
    );
END
GO

-- 3) Bulk load into raw table
BULK INSERT raw.simulated_hospital_admissions
FROM 'Simulated_Hospital_Admissions.csv'
WITH (
    DATA_SOURCE = 'clinical_blob_landing',
    FILE_TYPE = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0A',
    TABLOCK
);
GO
