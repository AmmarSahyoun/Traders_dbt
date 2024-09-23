{% set metadata_sat -%}   
target:  
  satellite_table_name: sat_customers_address
  hub_key: h_customer_main_key
  natural_key: customer_id

sources:
  - model_name: staging.stg_northwind__customers
    natural_keys: [customer_id]
    md_record_source: staging
    effective_dttm: load_dt
    columns:
      - s: address 
        t: address  
      - s: city
        t: city
      - s: state_province
        t: province
      - s: zip_postal_code
        t: zip_code
      - s: country_region
        t: country
      - s: web_page
        t: web_page
      - s: notes
        t: notes
      - s: attachments
        t: attachments

{%- endset %}

{{ satellite(fromyaml(metadata_sat)) }}
