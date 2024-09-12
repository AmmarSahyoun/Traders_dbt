{% macro satellite(metadata) %}

  {# Extract target-related metadata #}
  {%- set target_metadata = metadata['target'] if 'target' in metadata else {} %}
  {%- set hub_key = target_metadata.get('hub_key', '') %}
  {%- set natural_key = target_metadata.get('natural_key', '') %}

  {# Extract source-related metadata #}
  {%- set sources_metadata = metadata['sources'][0] if 'sources' in metadata and metadata['sources']|length > 0 else {} %}
  {%- set source_model = sources_metadata.get('model_name', '') %}
  {%- set effective_dttm = sources_metadata.get('effective_dttm', '') %}
  {%- set source_columns = sources_metadata.get('columns', []) %}


  {# Ensure source_columns is parsed as a list of dicts #}
  {%- if source_columns is string -%}
    {%- set source_columns = fromjson(source_columns | tojson) %}
  {%- endif %}

  {# Fallback logic if no source_model is defined #}
  {% if source_model == '' %}
    {{ exceptions.raise_compiler_error("No source model defined in metadata.") }}
  {% endif %}

  with hash_key as (
    select
      *, 
      {{ hashed_key(natural_key) }} as {{ hub_key }}
    from {{ source_model }}
  ),

  sat as (
    select
      {{ hub_key }},
      {{ effective_dttm }} as effective_dttm,
      {# Map source columns to target columns correctly #}
      {% for column in source_columns %}
        {{ column.src }} as {{ column.t }}{% if not loop.last %}, {% endif %}
      {% endfor %}
    from hash_key
  )

select * from sat

{% endmacro %}
