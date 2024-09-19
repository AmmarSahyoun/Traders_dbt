{% macro hub(metadata) %}

  {# Extract target-related metadata #}
  {%- set target_metadata = metadata['target'] if 'target' in metadata else {} %}
  {%- set hub_key = target_metadata.get('hub_key', '') %}
  {%- set natural_key = target_metadata.get('natural_key', '') %}

  {# Extract source-related metadata #}
  {%- set sources_metadata = metadata['sources'][0] if 'sources' in metadata and metadata['sources']|length > 0 else {} %}
  {%- set source_model = sources_metadata.get('model_name', '') %}
  {%- set record_source = metadata.get('record_source', 'unknown') %}
  {%- set batch_id = metadata.get('batch_id', "'{{ invocation_id }}'") %}
  {%- set load_dt = metadata.get('load_dt', 'current_timestamp::timestamp(0)') %}

  {# Fallback logic if no source_model is defined #}
  {% if source_model == '' %}
    {{ exceptions.raise_compiler_error("No source model defined in metadata.") }}
  {% endif %}

  {# Generate hub table with hashed key #}
  with hub_data as (
    select
      {{ hashed_key(natural_key) }} as {{ hub_key }},
      {{ natural_key }} as natural_key,
      {{ record_source }} as record_source,
      {{ batch_id }} as batch_id,
      {{ load_dt }} as load_dt
    from {{ source_model }}
  )

select * from hub_data

{% endmacro %}
