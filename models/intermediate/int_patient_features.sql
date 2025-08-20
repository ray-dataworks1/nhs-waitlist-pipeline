{{ config(materialized='view') }}

with p as (
  select
    patient_sk,
    patient_id,
    nhs_number,
    dob,
    gender,
    postcode
  from {{ ref('stg_patients') }}
),
cond as (
  select
    patient_id,
    count(*) as comorbidity_count
  from {{ ref('stg_conditions') }}
  group by 1
),
appt as (
  select
    patient_id,
    sum(case when appointment_status = 'CANCELLED' then 1 else 0 end) as cancellations_lifetime,
    sum(case when appointment_status = 'NO SHOW'  then 1 else 0 end) as dna_lifetime,
    max(appointment_date) as last_appointment_date
  from {{ ref('stg_appointments') }}
  where appointment_date is not null
  group by 1
)

select
  p.patient_sk,
  p.patient_id,
  p.nhs_number,
  p.dob,
  p.gender,
  p.postcode,
  {{ age_years('p.dob', as_of_date()) }} as age_years,
  coalesce(cond.comorbidity_count, 0)      as comorbidity_count,
  coalesce(appt.cancellations_lifetime, 0) as cancellations_lifetime,
  coalesce(appt.dna_lifetime, 0)           as dna_lifetime,
  appt.last_appointment_date
from p
left join cond using (patient_id)
left join appt using (patient_id)
