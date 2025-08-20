with raw as (
    select * from {{ ref('procedures') }}
),
clean as (
    select
        {{ dbt_utils.generate_surrogate_key(['procedure_id', 'patient_id']) }} as procedure_sk,
        procedure_id :: int as procedure_id,
        patient_id :: int as patient_id,
        upper(trim(procedure_name)) as procedure_name,
        to_date(planned_date, 'DD/MM/YYYY') as planned_date,
        to_date(actual_date, 'DD/MM/YYYY') as actual_date,
        initcap(trim(status)) as procedure_status
    from raw
)
select * from clean
