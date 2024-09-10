{% set metadata_sat -%}   

target:  
  satellite_table_name: sat_customers
  hub_key: h_customer_main_key
  natural_key: customer_id

sources:
  - model_name: stg_northwind__customers
    natural_keys: [customer_id]
    md_record_source: staging
    effective_dttm: load_dt
    columns:
      - s: company
        t: companyyy  
      - s: last_name
        t: NAMe_last

{%- endset %}

{{ dw_vault.satellite(metadata_sat) }}
