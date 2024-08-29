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
    date_allocated as effective_dt,
    jsonb_build_object('quantity', quantity, 'unit_price', unit_price, 'discount', discount
    ) as s_order_details_product,
    md_source,
    md_batch,
    md_load_dt
  from vault_prep
)


select
  h_order_details_product,
  l_order_details_product,
  effective_dt,
  s_order_details_product,
  md_source,
  md_batch,
  md_load_dt
from vlt_ensemble
where 1 = 1
