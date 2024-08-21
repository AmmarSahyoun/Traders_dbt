


  select 
    order_id,
    customer_id,
    order_date::date as order_dt,
    status_name as order_status
    coalesce(cast(order_id as varchar), '~~') || '##' || coalesce(cast(customer_id 
            as varchar), '~~') as h_order_customer_id,
    cast(
        ('x' || substr(md5(coalesce(cast(customer_id as varchar), '~~')), 1, 16))::bit(64)::bigint 
        as bigint
    ) as h_customer_key,

    cast(
        ('x' || substr(md5(coalesce(cast(order_id as varchar), '~~') || '##' ||
        coalesce(cast(customer_id as varchar), '~~')), 1, 16))::bit(64)::bigint 
        as bigint
    ) as h_order_customer_key,
    shipped_date::date,
    payment_type,
    paid_date::date,
    source_data,
    batch_id,
    load_dt
from
   staging.stg_northwind__orders;