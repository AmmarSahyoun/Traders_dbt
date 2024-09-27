{% set metadata_ensemble -%}
target:
  ensemble:
    name: vlt__e_order_customer
    partition_column: 
  hub:
    key: h_order_customer_key
    id: order_customer_id
  link:
    key:
      - [h_order_key, h_customer_key]
  satellite:
    effective_dttm: load_dt
    attributes:
      - trg: order_date
        src: order_date
      - trg: order_status
        src: status_name
      - trg: shipped_date
        src: shipped_date

sources:
  - model_name: staging.stg_northwind__orders
    hub:
      natural_keys:
        - order_id
        - customer_id
    link:
      hub_natural_keys:
        - [order_id]
        - [customer_id]   
    partition_column: 
    md_record_source: staging
    incremental: true
{%- endset %}
{{- ensemble(fromyaml(metadata_ensemble)) }}
