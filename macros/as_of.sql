{% macro as_of_date() -%}
  {% if var('as_of_date', '') != '' %}
    to_date('{{ var("as_of_date") }}')
  {% else %}
    current_date()
  {% endif %}
{%- endmacro %}
