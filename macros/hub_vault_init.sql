{% macro hub_init_load(metadata) %}

  {%- set target_metadata = metadata['target'] if 'target' in metadata else {} %}
  {%- set hub_key = target_metadata.get('hub_key', '') %}
  {%- set natural_key = target_metadata.get('natural_key', '') %}
  {%- set record_source = target_metadata.get('record_source', '') %}

  {%- set sources_metadata = metadata['sources'][0] if 'sources' in metadata and metadata['sources']|length > 0 else {} %}
  {%- set source_model = sources_metadata.get('model_name', '') %}

  {% if source_model == '' %}
    {{ exceptions.raise_compiler_error("No source model defined in metadata!") }}
  {% endif %}

   with hub as (
    select
      {{ hashed_key(natural_key) }} as {{ hub_key }},
      {{ natural_key }},  
      load_dt,
      load_dt as md_load_dt,
      '{{ record_source }}' as md_record_source,
      '{{ invocation_id }}' as md_batch
    from {{ source_model }}
  )

select 
  {{ hub_key }},
  {{ natural_key }}, 
  load_dt, 
  md_record_source,
  md_batch,
  md_load_dt
from hub

{% endmacro %}
