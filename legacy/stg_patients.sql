CREATE OR ALTER VIEW stg_patients AS
WITH base AS (
    SELECT
        TRY_CONVERT(INT, id)                                    AS legacy_patient_id,
        LTRIM(RTRIM(nhs_number))                                AS nhs_number,
        CASE 
            WHEN nhs_number IS NULL THEN 1
            WHEN LEN(REPLACE(nhs_number,' ','')) <> 10 THEN 1
            WHEN REPLACE(nhs_number,' ','') LIKE '%[^0-9]%' ESCAPE '\' THEN 1
            ELSE 0
        -- This checks if the NHS number is NULL, not 10 digits, or contains non-numeric characters. In the modern stack, this mod 11 check would be a  dbt macro or warehouse user defined function.
        END                                                     AS faulty_nhs_number_flag,
        LTRIM(RTRIM(first_name))                                AS first_name,
        LTRIM(RTRIM(last_name))                                 AS last_name,
        TRY_CONVERT(DATE, dob)                                  AS dob,
        LTRIM(RTRIM(gender))                                    AS sex_assigned_at_birth,
        LTRIM(RTRIM(postcode))                                  AS postcode,
        LTRIM(RTRIM(ethnicity))                                 AS ethnicity,
        LTRIM(RTRIM(risk_level))                                AS risk_level
    FROM patients
)
SELECT DISTINCT *
FROM base
WHERE legacy_patient_id IS NOT NULL
AND dob BETWEEN '1930-01-01' AND GETDATE();
