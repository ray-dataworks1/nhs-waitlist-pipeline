{{ config(materialized='view') }}

with appts as (
  select
    appointment_id,
    patient_id,
    trust_id,
    specialty,              -- already InitCap in staging
    appointment_date,
    appointment_status
  from {{ ref('stg_appointments') }}
),
ref_match as (
  /* Most recent referral for the same patient/specialty/trust on/ before the appointment */
  select
    a.appointment_id,
    r.referral_id,
    r.referral_date
  from appts a
  join {{ ref('stg_referrals') }} r
    on r.patient_id = a.patient_id
   and r.trust_id  = a.trust_id
   and r.specialty = a.specialty
   and r.referral_date <= a.appointment_date
  qualify row_number() over (
    partition by a.appointment_id
    order by r.referral_date desc
  ) = 1
)

select
  a.*,
  ref_match.referral_id,
  ref_match.referral_date,
  {{ weeks_between('ref_match.referral_date','a.appointment_date') }} as wait_weeks
from appts a
left join ref_match using (appointment_id)
