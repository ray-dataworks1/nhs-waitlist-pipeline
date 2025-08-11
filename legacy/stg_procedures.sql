CREATE OR ALTER VIEW stg_procedures AS
WITH base AS (
    SELECT
        TRY_CONVERT(INT, id)            AS legacy_procedure_id,
        TRY_CONVERT(INT, patient_id)    AS patient_id_fk,
        LTRIM(RTRIM(procedure_name))    AS procedure_name,
        TRY_CONVERT(DATETIME, planned_date) AS planned_date,
        TRY_CONVERT(DATETIME, actual_date)  AS actual_date,
        LTRIM(RTRIM(status))            AS status
    FROM procedures
)
SELECT DISTINCT *
FROM base
WHERE legacy_procedure_id IS NOT NULL
  AND patient_id_fk IS NOT NULL;
