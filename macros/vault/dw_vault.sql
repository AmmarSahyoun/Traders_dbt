{% macro satellite(metadata) %}
  {%- set sat_table_name = metadata['target']['satellite_table_name'] %}
  {%- set hub_key = metadata['target']['hub_key'] %}
  {%- set natural_key = metadata['target']['natural_key'] %}
  {%- set source_model = metadata['sources'][0]['model_name'] %}
  {%- set effective_dttm = metadata['sources'][0]['effective_dttm'] %}
  {%- set source_columns = metadata['sources'][0]['columns'] %}

  with source as (
    select
      ('x' || substr(md5(coalesce(nullif(upper(trim(cast({{ natural_key }} as varchar))), ''), '~~')), 1, 16))::bit(64)::bigint as {{ hub_key }},
      {{ effective_dttm }} as effective_dttm,

      -- Iterate over the columns and apply aliasing if provided
      {% for column in source_columns %}
        {{ column['SOURCE_COLUMN_NAME'] }} as {{ column['TARGET_COLUMNS_NAME'] }},
      {% endfor %}

      from {{ source_model }}
  )

 
  select 
    * 
  from source
{% endmacro %}
