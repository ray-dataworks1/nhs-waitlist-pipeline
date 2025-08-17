with raw as (
    select * from {{ ref('patients') }}
),
clean as (
    select
        {{ dbt_utils.generate_surrogate_key(['nhs_number']) }} as patient_sk,
        patient_id,
        {{ strip_non_digits('nhs_number') }} as nhs_number,
        initcap(trim(first_name)) as first_name,
        initcap(trim(last_name)) as last_name,
        try_to_date(dob) as dob,
        initcap(trim(gender)) as gender,
        upper(trim(postcode)) as postcode,
        initcap(trim(ethnicity)) as ethnicity,
        initcap(trim(risk_level)) as risk_level
    from raw
)
select * from clean
