CREATE OR ALTER VIEW stg_referrals AS
WITH base AS (
    SELECT
        TRY_CONVERT(INT, id)            AS legacy_referral_id,
        TRY_CONVERT(INT, patient_id)    AS patient_id_fk,
        TRY_CONVERT(INT, gp_id)         AS gp_id_fk,
        TRY_CONVERT(DATE, referral_date) AS referral_date,
        LTRIM(RTRIM(specialty))         AS specialty,
        LTRIM(RTRIM(reason))            AS reason,
        LTRIM(RTRIM(referral_status))   AS referral_status,
        TRY_CONVERT(INT, trust_id)      AS trust_id_fk,
        LTRIM(RTRIM(notes))             AS notes
    FROM referrals
)
SELECT DISTINCT *
FROM base
WHERE legacy_referral_id IS NOT NULL
  AND patient_id_fk IS NOT NULL;
