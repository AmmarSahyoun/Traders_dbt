with vault_prep as (
  select
    order_id,
    customer_id,
    cast(
      ('x' || substr(md5(
        coalesce(nullif(upper(trim(cast(order_id as varchar))), ''),'~~') || '##' || 
        coalesce(nullif(upper(trim(cast(customer_id as varchar))), ''), '~~')
            ), 1, 16))::bit(64)::bigint
        as bigint
        ) as h_order_customer_key,
    coalesce(nullif(upper(trim(cast(order_id as varchar))), ''), '~~') || '##' || 
    coalesce(nullif(upper(trim(cast(customer_id as varchar))), ''), '~~') 
          as order_customer_id,
    cast(
      ('x' || substr(md5(coalesce(nullif(upper(trim(cast(customer_id as varchar))), ''), '~~')
            ), 1, 16))::bit(64)::bigint
        as bigint
         ) as h_customer_key,
    cast(
      ('x' || substr(md5(coalesce(nullif(upper(trim(cast(order_id as varchar))), ''), '~~')
            ), 1, 16))::bit(64)::bigint
        as bigint
         ) as h_order_key,
    order_date::date as order_dt,
    order_date as effective_dt,
    status_name as order_status,
    shipped_date::date,
    notes,
    'staging' as md_source,
    '{{ invocation_id }}' as md_batch,
    current_timestamp::timestamp(0) as md_load_dt
  from
   {{ ref('stg_northwind__orders') }}
),


vlt_ensemble as (
  select
    jsonb_build_object(
      'h_order_customer_key', h_order_customer_key,
      'order_customer_id', order_customer_id
    ) as h_order_customer,
    jsonb_build_object(
      'h_customer_key', h_customer_key
    ) as l_order_customer,
    jsonb_build_object(
      'h_order_key', h_order_key
    ) as l_order_order_details,
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
  l_order_order_details,
  effective_dt,
  s_order_customer,
  md_source,
  md_batch,
  md_load_dt
from vlt_ensemble
where 1 = 1
