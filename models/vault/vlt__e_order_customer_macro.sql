{{ config (materialized='table')}}

{% set yaml_metadata %}
source_model: stg_northwind__orders
derived_columns:
    CUSTOMER_ID: customer_id
    ORDER_ID: order_id
    RECORD_SOURCE: '!staging_stg'
    EFFECTIVE_DATE: order_date
    LOAD_DATE: load_dt
hashed_columns:
    ORDER_HK: order_id
    CUSTOMER_HK: customer_id
    ORDER_CUSTOMER_HK:
        - order_id
        - customer_id
    ORDER_HD:
        is_hashdiff: true
        columns:
        - order_date
        - status_name
{% endset %}

{% set metadata_dict = fromyaml(yaml_metadata) %}

{{ automate_dv.stage(include_source_columns=true,
    source_model=metadata_dict['source_model'],
    derived_columns=metadata_dict['derived_columns'],
    null_columns=none,
    hashed_columns=metadata_dict['hashed_columns'],
    ranked_columns=none
        )}}