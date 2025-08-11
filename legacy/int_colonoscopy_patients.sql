CREATE OR ALTER VIEW int_colonoscopy_patients AS
SELECT
    p.legacy_patient_id,
    p.nhs_number,
    p.first_name,
    p.last_name,
    p.dob,
    p.risk_level,
    pr.legacy_procedure_id,
    pr.procedure_name,
    pr.planned_date,
    pr.actual_date,
    pr.status
FROM stg_patients      AS p
JOIN stg_procedures    AS pr
  ON pr.patient_id_fk = p.legacy_patient_id
WHERE pr.procedure_name = 'colonoscopy'
  AND pr.status = 'completed';
