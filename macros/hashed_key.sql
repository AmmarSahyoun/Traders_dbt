{% macro hashed_key(key) %}

  ('x' || substr(md5(coalesce(nullif(upper(trim(cast({{ key }}
      as varchar))), ''), '~~')), 1, 16))::bit(64)::bigint

{% endmacro %}
