with raw as (
    select * from {{ ref('procedures') }}
),
clean as (
    select
        {{ dbt_utils.generate_surrogate_key(['procedure_id', 'patient_id']) }} as procedure_sk,
        procedure_id,
        patient_id,
        upper(trim(procedure_name)) as procedure_name,
        try_to_date(planned_date) as planned_date,
        try_to_date(actual_date) as actual_date,
        initcap(trim(status))
    from raw
)
select * from clean
