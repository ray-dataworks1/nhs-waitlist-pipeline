with raw as (
    select * from {{ ref('appointments') }}
),
clean as (
    select
        {{ dbt_utils.generate_surrogate_key(['appointment_id', 'patient_id', 'appt_date']) }} as appointment_sk,
        appointment_id,
        patient_id,
        trust_id,
        initcap(trim(specialty)) as specialty,
        to_date(appt_date, 'DD/MM/YYYY') as appointment_date,
         case upper(trim(appt_status))
            when 'SCHEDULED'  then 'SCHEDULED'
            when 'COMPLETED'  then 'COMPLETED'
            when 'CANCELLED'  then 'CANCELLED'
            when 'NO-SHOW'    then 'NO SHOW'
            when 'RESCHEDULED'then 'RESCHEDULED'
            when 'OVERDUE'    then 'OVERDUE'
            else 'UNKNOWN'
        end as appointment_status,
        to_date(referral_date, 'DD/MM/YYYY') as referral_date,
        wait_weeks :: integer as wait_weeks
    from raw
)
select * from clean
