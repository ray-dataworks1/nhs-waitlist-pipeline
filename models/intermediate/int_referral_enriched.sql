{{ config(materialized='view') }}

with r as (
  select
    referral_id,
    patient_id,
    gp_id,
    trust_id,
    specialty,       -- InitCap
    referral_date,
    referral_status,
    reason,
    notes
  from {{ ref('stg_referrals') }}
),
first_appt as (
  /* First appointment AFTER the referral for same patient/specialty/trust */
  select
    r.referral_id,
    min(a.appointment_date) as first_appointment_date
  from r
  join {{ ref('stg_appointments') }} a
    on a.patient_id = r.patient_id
   and a.trust_id   = r.trust_id
   and a.specialty  = r.specialty
   and a.appointment_date >= r.referral_date
  group by 1
)

select
  r.*,
  first_appt.first_appointment_date,
  {{ weeks_between('r.referral_date','first_appt.first_appointment_date') }} as weeks_to_first_appointment
from r
left join first_appt using (referral_id)