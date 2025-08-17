{% macro weeks_between(start_expr, end_expr) -%}
    floor(datediff('day', {{ start_expr }}, {{ end_expr }}) / 7)
{%- endmacro %}

{% macro breach_flag(wait_weeks_expr, threshold_weeks) -%}
    case when {{ wait_weeks_expr }} > {{ threshold_weeks }} then 1 else 0 end
{%- endmacro %}
