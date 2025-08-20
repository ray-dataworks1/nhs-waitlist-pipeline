{{ config(materialized='view') }}

with p as (
  select
    procedure_id,
    patient_id,
    upper(trim(procedure_name)) as procedure_name,
    planned_date,
    actual_date,
    procedure_status
  from {{ ref('stg_procedures') }}
),
r_match as (
  /* We don’t have specialty/trust on procedures; attach the most recent referral before the procedure */
  select
    p.procedure_id,
    r.referral_id,
    r.referral_date
  from p
  join {{ ref('stg_referrals') }} r
    on r.patient_id = p.patient_id
   and r.referral_date <= coalesce(p.actual_date, p.planned_date)
  qualify row_number() over (
    partition by p.procedure_id
    order by r.referral_date desc
  ) = 1
)

select
  p.*,
  r_match.referral_id,
  r_match.referral_date,
  datediff('day', p.planned_date, p.actual_date) as procedure_wait_days,
  {{ weeks_between('r_match.referral_date','coalesce(p.actual_date, p.planned_date)') }} as rtt_weeks
from p
left join r_match using (procedure_id)