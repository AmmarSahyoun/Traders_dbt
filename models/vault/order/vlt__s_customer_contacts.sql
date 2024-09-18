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
      - src: company
        t: company  
      - src: last_name
        t: last_name
      - src: first_name
        t: first_name
      - src: email_address
        t: email
      - src: job_title
        t: job_title
      - src: business_phone
        t: business_phone
      - src: mobile_phone
        t: mobile

{%- endset %}

{{ satellite(fromyaml(metadata_sat)) }}
