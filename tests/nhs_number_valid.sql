{% test nhs_number_valid(model, column_name) %}

with base as (
  select {{ column_name }} as nhs
  from {{ model }}
),
violations as (
  select nhs
  from base
  where not {{ is_valid_nhs_number(nhs) }}
)

select * from violations

{% endtest %}
