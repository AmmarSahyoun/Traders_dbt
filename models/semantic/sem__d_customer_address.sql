{% set h_customer = ref('vlt__h_customer_main') -%}
{% set s_customer_address = ref('vlt__s_customer_address') -%}

select 
    h_customer.h_customer_key as d_customer_key, 
    h_customer.customer_id, 
    s_customer_address.country,
    s_customer_address.city,
    s_customer_address.address,
    s_customer_address.zip_code,
    'vlt' as md_record_source,
    h_customer.md_load_dt,
    '{{ invocation_id }}' md_batch
from {{ h_customer }} h_customer
left join {{ s_customer_address }} s_customer_address
  on h_customer.h_customer_key = s_customer_address.h_customer_main_key


