CREATE OR ALTER VIEW fct_risk_model AS
WITH agg AS (
    SELECT
        p.legacy_patient_id,
        p.nhs_number,
        p.first_name,
        p.last_name,
        p.dob,
        LOWER(p.risk_level)                         AS risk_level_text,
        COUNT(DISTINCT r.legacy_referral_id)        AS total_referrals,
        COUNT(DISTINCT pr.legacy_procedure_id)      AS total_procedures
        -- ,COUNT(DISTINCT a.legacy_appointment_id) AS total_appointments
        -- ,COUNT(DISTINCT c.legacy_condition_id)   AS total_conditions
    FROM stg_patients   AS p
    LEFT JOIN stg_referrals  AS r  ON r.patient_id_fk = p.legacy_patient_id
    LEFT JOIN stg_procedures AS pr ON pr.patient_id_fk = p.legacy_patient_id
    -- LEFT JOIN stg_appointments AS a ON a.patient_id_fk = p.legacy_patient_id
    -- LEFT JOIN stg_conditions   AS c ON c.patient_id_fk = p.legacy_patient_id
    GROUP BY
        p.legacy_patient_id, p.nhs_number, p.first_name, p.last_name, p.dob, p.risk_level
)
SELECT
    legacy_patient_id,
    nhs_number,
    first_name,
    last_name,
    DATEDIFF(YEAR, dob, GETDATE())                 AS age,
    CASE 
        WHEN DATEDIFF(YEAR, dob, GETDATE()) < 30 THEN '0-30'
        WHEN DATEDIFF(YEAR, dob, GETDATE()) BETWEEN 30 AND 59 THEN '30-60'
        ELSE '60+'
    END                                            AS age_cohort,
    risk_level_text,
    CASE 
        WHEN risk_level_text = 'high'   THEN 1
        WHEN risk_level_text = 'medium' THEN 2
        ELSE 3
    END                                            AS risk_level_numeric,
    total_referrals,
    total_procedures,
    NTILE(4) OVER (ORDER BY total_referrals DESC)  AS risk_quartile
    -- ,total_appointments
    -- ,total_conditions
FROM agg;
