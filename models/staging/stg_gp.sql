with raw as (
    select * from {{ ref('gp') }}
),
clean as (
    select
        {{ dbt_utils.generate_surrogate_key(['gp_id']) }} as gp_sk,
        gp_id :: int as gp_id,
        initcap(trim(name)) as gp_name,
        upper(trim(practice)) as practice,
        upper(trim(postcode)) as postcode
        
    from raw
)
select * from clean
