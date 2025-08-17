{{ config(materialized='view') }}

with referrals as (
  select referral_id, {{ strip_non_digits('nhs_number') }} as nhs_number,
         referral_date, upper(trim(urgency)) as urgency,
         upper(trim(specialty)) as specialty, trust_id, gp_id
  from {{ ref('stg_referrals') }}
),
appts as (
  select nhs_number, upper(trim(specialty)) as specialty, trust_id,
         min(appointment_date) as first_appointment_date
  from {{ ref('stg_appointments') }}
  group by 1,2,3
)
select
  referrals.*,
  appts.first_appointment_date,
  {{ weeks_between('referrals.referral_date', 'appts.first_appointment_date') }} as weeks_to_first_appointment
from referrals
left join appts
  on appts.nhs_number = referrals.nhs_number
 and appts.specialty  = referrals.specialty
 and appts.trust_id   = referrals.trust_id;
