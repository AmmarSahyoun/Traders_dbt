{{ config(materialized='incremental', unique_key='order_details_id')}}

with src as(
select 
  id as order_details_id, 
  order_id, 
  product_id, 
  quantity, 
  unit_price, 
  discount, 
  case 
    when status_id = 0 then 'Unknown'
    when status_id = 1 then 'Allocated'
    when status_id = 2 then 'Invoiced'
    when status_id = 3 then 'Shipped'
    when status_id = 4 then 'On Order'
    when status_id = 5 then 'No Stock'
  end as status_name, 
  date_allocated, 
  purchase_order_id, 
  inventory_id,
  '{{ invocation_id }}'  as batch_id,
  'db' as source_data,
  current_timestamp::timestamp(0) as load_dt
from {{ source('dbo','order_details') }}
),


ranked_src as(
  select
   *, row_number() over (partition by order_details_id, order_id, product_id order by order_details_id, order_id desc) as rnk
  from src
)
 

select 
  *
from ranked_src 
where 1=1
  and rnk = 1

  
{% if is_incremental() %}
    where current_timestamp > ( select max(load_dt) from {{this}} )
{% endif %}