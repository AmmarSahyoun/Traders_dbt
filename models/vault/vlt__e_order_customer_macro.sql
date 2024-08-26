{{ config (materialized='table')}}

{% set yml_metadata %}
source_model: stg_northwind__orders
derived_columns:
    CUSTOMER_ID: customer_id
    ORDER_ID: ORDER_ID
    RECORD_SOURCE: "staging_stg"
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