with raw as (
    select * from {{ ref('appointments') }}
),
clean as (
    select
        {{ dbt_utils.generate_surrogate_key(['appointment_id', 'patient_id', 'appt_date']) }} as appointment_sk,
        appointment_id,
        patient_id,
        trust_id,
        initcap(trim(specialty)),
        try_to_date(appt_date) as appointment_date,
        upper(trim(appt_status)) as appointment_status,
        try_to_date(referral_date),
        wait_weeks
    from raw
)
select * from clean
