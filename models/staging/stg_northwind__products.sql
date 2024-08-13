{{ config(materialized='incremental', unique_key = 'product_id')}}

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

  
{% if is_incremental() %}
  where current_timestamp > (select max(load_dt) from {{ this }})
{% endif %}