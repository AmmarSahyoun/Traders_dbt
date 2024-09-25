{% set metadata_hub -%}
target:
  hub_key: h_customer_key
  natural_key: customer_id
  record_source: staging
  
sources:
  - model_name: staging.stg_northwind__customers
    natural_keys:
      - customer_id


{%- endset %}

{{ hub(fromyaml(metadata_hub)) }}