with ranked_src as (
  select 
    *,
    row_number() over (partition by id, order_id, product_id order by id, order_id desc) as rnk
  from {{ source('dbo','order_details') }}
),

latest as (
  select *
  from ranked_src where rnk = 1
),


filtered_data as (
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
    '{{ invocation_id }}' as batch_id,
    'db' as source_data,
    load_dt as load_dt
  from latest
)

select 
  order_details_id,
  order_id,
  product_id,
  quantity,
  unit_price, 
  discount, 
  status_name,
  date_allocated,
  purchase_order_id,
  inventory_id,
  batch_id,
  source_data,
  load_dt
from filtered_data
where 1=1