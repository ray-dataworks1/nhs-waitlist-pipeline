with raw as (
    select * from {{ ref('referrals') }}
),
clean as (
    select
        {{ dbt_utils.generate_surrogate_key(['referral_id', 'gp_id', 'referral_date']) }} as referral_sk,
        referral_id :: int as referral_id,
        patient_id :: int as patient_id,
        gp_id :: int as gp_id,
        to_date(referral_date, 'DD/MM/YYYY') as referral_date,
        initcap(trim(specialty)) as specialty,
        lower(trim(reason)) as reason,
        initcap(trim(referral_status)) as referral_status,
        trust_id :: int as trust_id,
        lower(trim(notes)) as notes
    from raw
)
select * from clean
