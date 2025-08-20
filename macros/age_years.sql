{% macro age_years(dob_col, as_of_date_col) %}
  datediff(year, {{ dob_col }}, {{ as_of_date_col }})
{% endmacro %}
