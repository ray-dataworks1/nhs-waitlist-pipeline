with raw as (
    select * from {{ ref('trusts') }}
),
clean as (
    select
        {{ dbt_utils.generate_surrogate_key(['trust_id']) }} as trust_sk,
        trust_id :: int,
        initcap(trim(name)) as trust_name,
        initcap(trim(region))
    from raw
)
select * from clean
