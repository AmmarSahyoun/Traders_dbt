{% set metadata_sat -%}   
target:  
  satellite_table_name: sat_customers_contacts
  hub_key: h_customer_main_key
  natural_key: customer_id

sources:
  - model_name: staging.stg_northwind__customers
    natural_keys: [customer_id]
    md_record_source: staging
    effective_dttm: load_dt
    columns:
      - s: company
        t: company  
      - s: last_name
        t: last_name
      - s: first_name
        t: first_name
      - s: email_address
        t: email
      - s: job_title
        t: job_title
      - s: business_phone
        t: business_phone
      - s: mobile_phone
        t: mobile

{%- endset %}

{{ satellite(fromyaml(metadata_sat)) }}
