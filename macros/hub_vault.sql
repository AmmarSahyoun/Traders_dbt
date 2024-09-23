{% macro hub(metadata, md_batch, md_load_dt) %}

  {# Extract target-related metadata #}
  {%- set target_metadata = metadata['target'] if 'target' in metadata else {} %}
  {%- set hub_key = target_metadata.get('hub_key', '') %}
  {%- set natural_key = target_metadata.get('natural_key', '') %}

  {# Extract source-related metadata #}
  {%- set sources_metadata = metadata['sources'][0] if 'sources' in metadata and metadata['sources']|length > 0 else {} %}
  {%- set source_model = sources_metadata.get('model_name', '') %}
  {%- set md_record_source = metadata.get('md_record_source', 'unknown') %}

  {# Fallback logic if no source_model is defined #}
  {% if source_model == '' %}
    {{ exceptions.raise_compiler_error("No source model defined in metadata.") }}
  {% endif %}

  {# Ensure md_batch and md_load_dt are treated as strings #}
  {%- set md_batch_str = "'" ~ md_batch ~ "'" %}
  {%- set md_load_dt_str = "'" ~ md_load_dt ~ "'" %}

  {# Generate hub table with hashed key #}
  with hub_data as (
    select
      {{ hashed_key(natural_key) }} as {{ hub_key }},
      '{{ md_record_source }}' as md_record_source,
      {{ md_batch_str }} as md_batch,
      {{ md_load_dt_str }} as md_load_dt
    from {{ source_model }}
  )

select * from hub_data

{% endmacro %}
