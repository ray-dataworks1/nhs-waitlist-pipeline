{{ config(materialized='view') }}

with a as (
  select
    trust_id,
    specialty,  -- InitCap
    date_trunc('week', appointment_date) as week_start,
    appointment_status
  from {{ ref('stg_appointments') }}
  where appointment_date is not null
)

select
  trust_id,
  specialty,
  week_start,
  count(*) as total_slots,
  /* Planned = scheduled (incl. rescheduled) */
  sum(case when appointment_status in ('SCHEDULED','RESCHEDULED') then 1 else 0 end) as planned_slots,
  /* Attended = completed */
  sum(case when appointment_status = 'COMPLETED' then 1 else 0 end)                  as attended_slots,
  sum(case when appointment_status = 'CANCELLED' then 1 else 0 end)                  as cancelled_slots,
  /* DNA = “NO SHOW” */
  sum(case when appointment_status = 'NO-SHOW' then 1 else 0 end)                    as dna_slots
from a
group by 1,2,3

