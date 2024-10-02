{% set metadata_hub -%}
target:
  hub_key: h_employee_key
  natural_key: employee_id
  record_source: staging
  
sources:
  - model_name: staging.stg_northwind__employees
    natural_keys:
      - employee_id


{%- endset %}

{{ hub_init_load(fromyaml(metadata_hub)) }}