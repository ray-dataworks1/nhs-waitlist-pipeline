with raw as (
    select * from {{ ref('conditions') }}
),
clean as (
    select
        {{ dbt_utils.generate_surrogate_key(['condition_id', 'patient_id', 'active']) }} as condition_sk,
        condition_id:: int as condition_id,
        patient_id :: int as patient_id,
        initcap(trim(condition_name)) as condition_name,
        initcap(trim(severity)) as severity,
        initcap(trim(active)) as active
    from raw
)
select * from clean
