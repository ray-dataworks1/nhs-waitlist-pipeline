with raw as (
    select * from {{ ref('conditions') }}
),
clean as (
    select
        {{ dbt_utils.generate_surrogate_key(['condition_id', 'patient_id', 'active']) }} as condition_sk,
        condition_id,
        patient_id,
        initcap(trim(condition_name)) as condition_name,
        initcap(trim(severity)),
        initcap(trim(active))
    from raw
)
select * from clean
