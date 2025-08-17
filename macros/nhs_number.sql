{% macro strip_non_digits(txt) -%}
    regexp_replace({{ txt }}, '[^0-9]', '')
{%- endmacro %}

{% macro is_all_digits(txt) -%}
    regexp_like({{ txt }}, '^[0-9]+$')
{%- endmacro %}
-- checksum section
{# NHS number must be 10 digits. Check digit = 11 - (sum(d[i] * (11-i)) % 11)
   If result = 11 → 0; if result = 10 → invalid; must equal digit 10. #}
{% macro is_valid_nhs_number(nhs_txt) -%}
    (
      length({{ strip_non_digits(nhs_txt) }}) = 10
      AND 
      (
        case
          when {{ is_all_digits(strip_non_digits(nhs_txt)) }} then
            /* Snowflake: get digits via substr */
            /* d1..d10 as integers */
            with d as (
              select
                to_number(substr({{ strip_non_digits(nhs_txt) }}, 1, 1)) as d1,
                to_number(substr({{ strip_non_digits(nhs_txt) }}, 2, 1)) as d2,
                to_number(substr({{ strip_non_digits(nhs_txt) }}, 3, 1)) as d3,
                to_number(substr({{ strip_non_digits(nhs_txt) }}, 4, 1)) as d4,
                to_number(substr({{ strip_non_digits(nhs_txt) }}, 5, 1)) as d5,
                to_number(substr({{ strip_non_digits(nhs_txt) }}, 6, 1)) as d6,
                to_number(substr({{ strip_non_digits(nhs_txt) }}, 7, 1)) as d7,
                to_number(substr({{ strip_non_digits(nhs_txt) }}, 8, 1)) as d8,
                to_number(substr({{ strip_non_digits(nhs_txt) }}, 9, 1)) as d9,
                to_number(substr({{ strip_non_digits(nhs_txt) }},10, 1)) as d10
            )
            select
              /* Compute check digit from first 9 digits */
              (case
                 when ((11 - ((d1*10 + d2*9 + d3*8 + d4*7 + d5*6 + d6*5 + d7*4 + d8*3 + d9*2) % 11)) % 11) = d10
                      and ((11 - ((d1*10 + d2*9 + d3*8 + d4*7 + d5*6 + d6*5 + d7*4 + d8*3 + d9*2) % 11)) != 10)
                   then true
                 else false
               end)
            from d
          else false
        end
      )
    )
{%- endmacro %}
