{% set metadata_ensemble -%}
target:
  ensemble:
    name: vlt__e_order_main
    partition_column: date(load_dt)
  hub:
    key: h_order_main_key
    id: order_main_id
  link:
    keys:
      - [h_customer_main_key, h_shipper_key, h_employee_key]
  satellite:
    effective_dttm: load_dt
    attributes:
      - trg: order_date
        src: order_date
      - trg: order_status
        src: status_name
      - trg: payment_type
        src: payment_type
      - trg: paid_date
        src: paid_date        
      - trg: shipped_date
        src: shipped_date
      - trg: taxes
        src: taxes
      - trg: tax_status_name
        src: tax_status_name
      - trg: tax_rate
        src: tax_rate
      - trg: status_name
        src: status_name
      - trg: notes
        src: notes

sources:
  - model_name: staging.stg_northwind__orders
    hub:
      natural_keys:
        - order_id

    link:
      hub_natural_keys:
        - [customer_id]   
        - [shipper_id] 
        - [employee_id] 
    partition_column: 
    md_record_source: staging
    incremental: true
{%- endset %}
{{- ensemble(fromyaml(metadata_ensemble)) }}