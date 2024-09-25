{% macro hub(metadata) %}

  {%- set target_metadata = metadata['target'] if 'target' in metadata else {} %}
  {%- set hub_key = target_metadata.get('hub_key', '') %}
  {%- set natural_key = target_metadata.get('natural_key', '') %}
  {%- set record_source = target_metadata.get('record_source', '') %}

  {%- set sources_metadata = metadata['sources'][0] if 'sources' in metadata and metadata['sources']|length > 0 else {} %}
  {%- set source_model = sources_metadata.get('model_name', '') %}

  {% if source_model == '' %}
    {{ exceptions.raise_compiler_error("No source model defined in metadata!") }}
  {% endif %}

  {{ config(materialized='incremental', unique_key = natural_key)}}

  with hash_key as (
    select
      {{ hashed_key(natural_key) }} as {{ hub_key }},
      {{ natural_key }},
      load_dt
    from {{ source_model }}
  ),

  hub as (
    select
      {{ hub_key }},
      {{ natural_key }},  -- Ensure natural_key (customer_id) is selected
      load_dt,
      load_dt as md_load_dt,
      '{{ record_source }}' as md_record_source,
      '{{ invocation_id }}' as md_batch
    from hash_key
  )

select 
  {{ hub_key }},
  {{ natural_key }},  -- Include natural_key for use in deletion
  md_record_source,
  md_batch,
  md_load_dt
from hub

{% if is_incremental() %}
  where load_dt > (select max(md_load_dt::timestamp) from {{this}})
{% endif %}

{% endmacro %}
