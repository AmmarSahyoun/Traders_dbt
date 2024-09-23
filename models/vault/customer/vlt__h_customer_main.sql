{% set metadata_hub -%}
target:
  hub_key: h_customer_key
  natural_key: customer_id
sources:
  - model_name: staging.stg_northwind__customers
    natural_keys:
      - customer_id

md_record_source: staging
{%- endset %}

{{ hub(fromyaml(metadata_hub), invocation_id, run_started_at) }}
