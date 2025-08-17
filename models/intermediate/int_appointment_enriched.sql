{{ config(materialized='view') }}

with appts as (
  select appointment_id, nhs_number, appointment_date,
         upper(trim(status)) as status, trust_id, upper(trim(specialty)) as specialty
  from {{ ref('stg_appointments') }}
),
ref_match as (
  select
    a.appointment_id,
    r.referral_id,
    r.referral_date
  from a
  join {{ ref('stg_referrals') }} r
    on r.nhs_number = a.nhs_number
   and upper(trim(r.specialty)) = a.specialty
   and r.trust_id = a.trust_id
   and r.referral_date <= a.appointment_date
  qualify row_number() over (partition by a.appointment_id
                             order by r.referral_date desc) = 1
)
select
  appts.*,
  ref_match.referral_id,
  ref_match.referral_date,
  {{ weeks_between('ref_match.referral_date', 'appts.appointment_date') }} as wait_weeks
from appts
left join ref_match using (appointment_id);
{{ config(materialized='view') }}

with appts as (
  select appointment_id, nhs_number, appointment_date,
         upper(trim(status)) as status, trust_id, upper(trim(specialty)) as specialty
  from {{ ref('stg_appointments') }}
),
ref_match as (
  select
    a.appointment_id,
    r.referral_id,
    r.referral_date
  from a
  join {{ ref('stg_referrals') }} r
    on r.nhs_number = a.nhs_number
   and upper(trim(r.specialty)) = a.specialty
   and r.trust_id = a.trust_id
   and r.referral_date <= a.appointment_date
  qualify row_number() over (partition by a.appointment_id
                             order by r.referral_date desc) = 1
)
select
  appts.*,
  ref_match.referral_id,
  ref_match.referral_date,
  {{ weeks_between('r_match.referral_date', 'a.appointment_date') }} as wait_weeks
from appts
left join ref_match using (appointment_id);
