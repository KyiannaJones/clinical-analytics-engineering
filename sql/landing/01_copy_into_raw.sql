-- 1) Credential using a SAS token
IF NOT EXISTS (SELECT 1 FROM sys.database_scoped_credentials WHERE name = 'blob_sas_credential')
BEGIN
  CREATE DATABASE SCOPED CREDENTIAL blob_sas_credential
  WITH IDENTITY = 'SHARED ACCESS SIGNATURE',
  SECRET = '***REDACTED***';
END
GO

-- 2) External data source pointing to the container
IF NOT EXISTS (SELECT 1 FROM sys.external_data_sources WHERE name = 'clinical_blob_landing')
BEGIN
  CREATE EXTERNAL DATA SOURCE clinical_blob_landing
  WITH (
    TYPE = BLOB_STORAGE,
    LOCATION = 'https://clinicalanalyticskj.blob.core.windows.net/landing',
    CREDENTIAL = blob_sas_credential
  );
END
GO

-- 3) Load CSV into raw table
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
