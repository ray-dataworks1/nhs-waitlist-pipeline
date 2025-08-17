{% macro age_band(age_expr) -%}
    case
      when {{ age_expr }} is null then 'unknown'
      when {{ age_expr }} < 18   then '0-17'
      when {{ age_expr }} between 18 and 29 then '18-29'
      when {{ age_expr }} between 30 and 44 then '30-44'
      when {{ age_expr }} between 45 and 59 then '45-59'
      when {{ age_expr }} between 60 and 74 then '60-74'
      else '75+'
    end
{%- endmacro %}
