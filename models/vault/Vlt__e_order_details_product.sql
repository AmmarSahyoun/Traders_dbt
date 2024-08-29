with vault_prep as (
  select
    order_details_id,
    order_id,
    product_id,
    cast(
      ('x' || substr(md5(
        coalesce(nullif(upper(trim(cast(order_details_id as varchar))), ''),'~~') || '##' || 
        coalesce(nullif(upper(trim(cast(product_id as varchar))), ''), '~~')
            ), 1, 16))::bit(64)::bigint
        as bigint
        ) as h_order_details_product_key,
    coalesce(nullif(upper(trim(cast(order_details_id as varchar))), ''), '~~') || '##' || 
    coalesce(nullif(upper(trim(cast(product_id as varchar))), ''), '~~') 
          as  order_details_product_id,
    cast(
      ('x' || substr(md5(coalesce(nullif(upper(trim(cast(product_id as varchar))), ''), '~~')
            ), 1, 16))::bit(64)::bigint
        as bigint
         ) as h_product_key,
    cast(
      ('x' || substr(md5(coalesce(nullif(upper(trim(cast(order_id as varchar))), ''), '~~')
            ), 1, 16))::bit(64)::bigint
        as bigint
         ) as h_order_key,
    quantity,
    unit_price,
    discount,
    date_allocated::date,
    'staging' as md_source,
    '{{ invocation_id }}' as md_batch,
    current_timestamp::timestamp(0) as md_load_dt
  from
   {{ ref('stg_northwind__order_details') }}
),


vlt_ensemble as (
  select
    jsonb_build_object(
      'h_order_details_product_key', h_order_details_product_key,
      'order_details_product_id', order_details_product_id
    ) as h_order_details_product,
    jsonb_build_object(
      'h_product_key', h_product_key,
      'h_order_key', h_order_key
    ) as l_order_details_product,
    effective_dt,
    jsonb_build_object('order_dt', order_dt, 'order_status', order_status, 'shipped_date', shipped_date,
      'notes', notes
    ) as s_order_customer,
    md_source,
    md_batch,
    md_load_dt
  from vault_prep
)


select
  h_order_customer,
  l_order_customer,
  effective_dt,
  s_order_customer,
  md_source,
  md_batch,
  md_load_dt
from vlt_ensemble
where 1 = 1
