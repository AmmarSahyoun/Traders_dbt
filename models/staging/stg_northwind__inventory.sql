with ranked_src as (
  select
    *,
    row_number() over (partition by id, product_id, purchase_order_id order by transaction_created_date asc, transaction_modified_date desc) as rnk
  from {{ source('dbo','inventory_transactions') }}
),


latest as (
  select *
  from ranked_src where rnk = 1
)


select
  id as inventory_id,
  case
    when transaction_type = 1 then 'Purchased'
    when transaction_type = 2 then 'Sold'
    when transaction_type = 3 then 'On Hold'
    when transaction_type = 4 then 'Waste'
  end as transaction_name,
  transaction_created_date::date,
  transaction_modified_date::date,
  product_id,
  quantity,
  purchase_order_id,
  customer_order_id,
  comments,
  '{{ invocation_id }}' as batch_id,
  'db' as source_data,
  load_dt as load_dt
from latest