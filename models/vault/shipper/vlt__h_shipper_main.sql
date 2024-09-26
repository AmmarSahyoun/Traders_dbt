{% set metadata_hub -%}
target:
  hub_key: h_shipper_key
  natural_key: shipper_id
  record_source: staging
  
sources:
  - model_name: staging.stg_northwind__shippers
    natural_keys:
      - shipper_id


{%- endset %}

{{ hub_init_load(fromyaml(metadata_hub)) }}