with src as(
select 
	*
from {{ source('dbo','products') }} where id is not null
)

select 
  supplier_ids,
  id as product_id,
  product_code, 
  product_name, 
  description, 
  standard_cost, 
  list_price, 
  reorder_level, 
  target_level, 
  quantity_per_unit, 
  discontinued, 
  minimum_reorder_quantity, 
  category, 
  attachments,  
  '{{ invocation_id }}'  as batch_id,
  'db' as source_data,
  current_timestamp::timestamp(0) as load_dt
from src