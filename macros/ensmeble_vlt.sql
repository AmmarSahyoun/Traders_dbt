{% macro ensemble(metadata) %}
    {%- set target_metadata = metadata.target %}
    {%- set hub_metadata = target_metadata.hub %}
    {%- set satellite_metadata = target_metadata.satellite %}
    {%- set sources_metadata = metadata.sources[0] %}
    
    {%- set hub_natural_keys = sources_metadata.hub.natural_keys %}
    {%- set link_hub_natural_keys = sources_metadata.link.hub_natural_keys %}
    
    with preparation as (
        select
            {% if hub_natural_keys | length == 1 %}
                {{ hub_natural_keys[0] }} as {{ hub_metadata.id }},
                {{ hashed_key(hub_natural_keys[0]) }} as {{ hub_metadata.key }},
            {% else %}
                {{ concat_natural_keys(hub_natural_keys) }} as {{ hub_metadata.id }},
                {{ hashed_key(concat_natural_keys(hub_natural_keys)) }} as {{ hub_metadata.key }},
            {% endif %}
            {% for natural_key in link_hub_natural_keys %}
                {%- set hashed_key_name = 'h_' ~ natural_key[0] | replace('_id', '_key') %}
                {{ hashed_key(natural_key[0]) }} as {{ hashed_key_name }}{% if not loop.last %},{% endif %}
            {% endfor %},
            {% for attribute in satellite_metadata.attributes %}
                {{ attribute.src }} as {{ attribute.trg }}{% if not loop.last %},{% endif %}
            {% endfor %},
            '{{ sources_metadata.md_record_source }}' as md_source,
            '{{ invocation_id }}' as md_batch,
            {{ satellite_metadata.effective_dttm }} as md_load_dt
        from {{ sources_metadata.model_name }}
    ),
    
    ensemble as (
        select
            jsonb_build_object(
                '{{ hub_metadata.key }}', {{ hub_metadata.key }},
                '{{ hub_metadata.id }}', {{ hub_metadata.id }}
            ) as h_order_customer,
            jsonb_build_object(
                {% for natural_key in link_hub_natural_keys %}
                    {%- set hashed_key_name = 'h_' ~ natural_key[0] | replace('_id', '_key') %}
                    '{{ hashed_key_name }}', {{ hashed_key_name }}{% if not loop.last %},{% endif %}
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
    
    select
        h_order_customer,
        l_order_customer,
        s_order_customer,
        md_source,
        md_batch,
        md_load_dt
    from ensemble
    where 1 = 1
{% endmacro %}
