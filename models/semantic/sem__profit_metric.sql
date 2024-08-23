with inventory_transactions_with_profit as (
  select
    it.*,
    it.quantity * (p.list_price - p.standard_cost) as transaction_profit,
    (it.quantity * (p.list_price - p.standard_cost)) / (it.quantity * p.list_price) as transaction_margin
  from staging.stg_northwind__inventory as it
  inner join staging.stg_northwind__products as p on it.product_id = p.product_id
),


product_profit_margin_cte as (
  select
    product_id,
    AVG(transaction_margin) as product_profit_margin
  from inventory_transactions_with_profit
  group by product_id
),


supplier_profit_margin_cte as (
  select
    p.supplier_ids,
    AVG(itwp.transaction_margin) as supplier_profit_margin
  from inventory_transactions_with_profit as itwp
  inner join staging.stg_northwind__products as p on itwp.product_id = p.product_id
  group by p.supplier_ids
)

select
  itwp.inventory_id,
  itwp.transaction_name,
  itwp.transaction_created_date,
  itwp.transaction_modified_date,
  itwp.product_id,
  itwp.quantity,
  itwp.purchase_order_id,
  itwp.customer_order_id,
  itwp.comments,
  ppm.product_profit_margin,
  spm.supplier_profit_margin,
  '{{ invocation_id }}' as md_batch_id,
  'staging' as md_source_data,
  CURRENT_TIMESTAMP::timestamp(0) as md_load_dt
from inventory_transactions_with_profit as itwp
left join product_profit_margin_cte as ppm on itwp.product_id = ppm.product_id
left join supplier_profit_margin_cte as spm on itwp.product_id in (
    select p.product_id
    from staging.stg_northwind__products as p
    where p.supplier_ids = spm.supplier_ids
)
