with prep_vault as (
  select
    order_id,
    customer_id,
    cast(
      ('x' || substr(md5(coalesce(cast(order_id as varchar), '~~') || '##'
        || coalesce(cast(customer_id as varchar), '~~')), 1, 16))::bit(64)::bigint
      as bigint
    ) as h_order_customer_key,
    coalesce(cast(order_id as varchar), '~~') || '##' || coalesce(cast(customer_id
        as varchar), '~~') as order_customer_id,
    cast(
      ('x' || substr(md5(coalesce(cast(customer_id as varchar), '~~')), 1, 16))::bit(64)::bigint
      as bigint
    ) as h_customer_key,
    order_date::date as order_dt,
    order_date as effective_dt,
    status_name as order_status,
    shipped_date::date,
    notes,
    'staging' as md_source,
    '{{ invocation_id }}' as md_batch,
    current_timestamp::timestamp(0) as md_load_dt
  from
    staging.stg_northwind__orders
),


ensemble_vlt as (
  select
    jsonb_build_object(
      'h_order_customer_key', h_order_customer_key,
      'order_customer_id', order_customer_id
    ) as h_order_customer,
    jsonb_build_object(
      'h_customer_key', h_customer_key
    ) as l_order_customer,
    effective_dt,
    jsonb_build_object('order_dt', order_dt, 'order_status', order_status, 'shipped_date', shipped_date,
      'notes', notes
    ) as s_order_customer,
    md_source,
    md_batch,
    md_load_dt,
    row_number() over (partition by h_customer_key, order_id, effective_dt order by effective_dt) as rnk
  from prep_vault
)


select
  h_order_customer,
  l_order_customer,
  effective_dt,
  s_order_customer,
  md_source,
  md_batch,
  md_load_dt
from ensemble_vlt where 1 = 1
  and rnk = 1
