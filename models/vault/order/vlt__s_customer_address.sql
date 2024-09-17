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
      - src: address 
        t: address  
      - src: city
        t: city
      - src: state_province
        t: province
      - src: zip_postal_code
        t: zip_code
      - src: country_region
        t: country
      - src: web_page
        t: web_page
      - src: notes
        t: notes
      - src: attachments
        t: attachments

{%- endset %}

{{ satellite(fromyaml(metadata_sat)) }}
