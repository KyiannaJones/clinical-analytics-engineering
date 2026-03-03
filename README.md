#Clinical Admissions Analytics Engineering Project

Overview
This project demonstrates an end-to-end analytics engineering workflow using a simulated hospital admissions dataset. The goal was to move beyond simple dashboarding and build a structured, production-style data model using layered architecture and dimensional modeling principles.

I intentionally designed this project to reflect how data flows in a real environment: ingestion, transformation, validation, and analytics-ready modeling.


Architecture
Blob Storage (Landing)
- Azure Data Factory (Ingestion Pipeline)
- Azure SQL Database

Structured into layered schemas:
- raw – source-of-truth ingestion table
- staging – transformation layer with deterministic Admission_ID logic
- marts – star schema (dimension tables + fact table)
This separation ensures clarity, maintainability, and controlled business logic application.


Key Engineering Decisions
- Created a deterministic Admission_ID because the dataset lacked a natural encounter key
- Separated raw vs. staging to prevent business logic contamination of source data
- Built a full star schema with surrogate keys
- Implemented validation queries to confirm row integrity and uniqueness
- Designed fact table with proper foreign key relationships to dimension tables

Final Model Includes:
- dim_patient (500)
- dim_department (9)
- dim_condition (10)
- dim_insurance (4)
- fact_admissions_star (500)


Data Quality Validation
- Raw vs staging vs mart row counts validated
- Admission_ID uniqueness confirmed
- Null checks on critical fields

Tools Used
- Azure SQL Database
- Azure Data Factory
- Azure Blob Storage
- VS Code (SQL execution)
- GitHub (version control + documentation)


Why This Project Matters
This project reflects the transition from traditional analytics to analytics engineering. Instead of focusing only on reporting outputs, the emphasis was placed on data modeling, structured transformations, reproducibility, and clean architecture.

This approach ensures downstream analytics tools (Power BI, etc.) connect to a reliable, well-designed warehouse layer rather than raw transactional data.
