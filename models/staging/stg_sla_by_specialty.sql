with raw as (
    select * from {{ ref('sla_by_specialty') }}
),
clean as (
    select
        {{ dbt_utils.generate_surrogate_key(['specialty', 'rtt_weeks_threshold']) }} as sla_sk,
        initcap(trim(specialty)) as specialty,
        rtt_weeks_threshold::int as rtt_weeks_threshold,

        case when rtt_weeks_threshold < 18 or rtt_weeks_threshold > 18  then 1 else 0 end as verification_needed,

    from raw
)
select * from clean