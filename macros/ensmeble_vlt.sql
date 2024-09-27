{% macro ensemble(metadata) %}
    -- Extract metadata
    {%- set target_metadata = metadata.target %}
    {%- set hub_metadata = target_metadata.hub %}
    {%- set link_metadata = target_metadata.link %}
    {%- set satellite_metadata = target_metadata.satellite %}
    {%- set sources_metadata = metadata.sources[0] %}
    
    {%- set hub_natural_keys = sources_metadata.hub.natural_keys %}
    {%- set link_hub_natural_keys = sources_metadata.link.hub_natural_keys %}
    
    -- Configuration for incremental loading
  --  {{ config(materialized='incremental', unique_key=hub_natural_keys) }}
    
    -- Preparation Section
    with preparation as (
        select
            -- Handling the hub keys
            {{ concat_natural_keys(hub_natural_keys) }} as {{ hub_metadata.id }},
            {{ hashed_key(concat_natural_keys(hub_natural_keys)) }} as {{ hub_metadata.key }},
            
            -- Handling the link keys: Using "order_id" and "customer_id" instead of "h_order_key" and "h_customer_key"
            {% for link_key_pair in link_metadata.key %}
                {{ concat_natural_keys(link_hub_natural_keys[loop.index0]) }} as h_{{ link_key_pair[0] }}_{{ link_key_pair[1] }},
                {{ hashed_key(concat_natural_keys(link_hub_natural_keys[loop.index0])) }} as l_{{ link_key_pair[0] }}_{{ link_key_pair[1] }},
            {% endfor %}
            
            -- Handling satellite attributes
            {% for attribute in satellite_metadata.attributes %}
                {{ attribute.src }} as {{ attribute.trg }},
            {% endfor %}
            
            -- Metadata fields
            '{{ sources_metadata.md_record_source }}' as md_source,
            '{{ invocation_id }}' as md_batch,
            {{ satellite_metadata.effective_dttm }} as md_load_dt
        from {{ sources_metadata.model_name }}
    ),
    
    -- Ensemble Section
    ensemble as (
        select
            jsonb_build_object(
                '{{ hub_metadata.key }}', {{ hub_metadata.key }},
                '{{ hub_metadata.id }}', {{ hub_metadata.id }}
            ) as h_order_customer,
            jsonb_build_object(
                {% for link_key_pair in link_metadata.key %}
                    'l_{{ link_key_pair[0] }}_{{ link_key_pair[1] }}', l_{{ link_key_pair[0] }}_{{ link_key_pair[1] }}{% if not loop.last %},{% endif %}
                {% endfor %}
            ) as l_order_customer,
            jsonb_build_object(
                {% for attribute in satellite_metadata.attributes %}
                    '{{ attribute.trg }}', {{ attribute.trg }}{% if not loop.last %},{% endif %}
                {% endfor %}
            ) as s_order_customer,
            md_source,
            md_batch,
            md_load_dt
        from preparation
    )
    
    -- Final output
    select
        h_order_customer,
        l_order_customer,
        s_order_customer,
        md_source,
        md_batch,
        md_load_dt
    from ensemble
    where 1 = 1
  /*  
    {% if is_incremental() %}
        and {{ satellite_metadata.effective_dttm }} > (select max(md_load_dt) from {{ this }})
    {% endif %}
    */
{% endmacro %}
