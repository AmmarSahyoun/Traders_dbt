{{ config(materialized='incremental', unique_key='purchase_order_id')}}

with ranked_src as (
  select
    *,
    row_number() over (partition by id, supplier_id, creation_date, approved_date order by id asc, creation_date desc) as rnk
  from {{ source('dbo','purchase_orders') }}
),


latest as (
  select *
  from ranked_src where rnk = 1
)


select
  id as purchase_order_id,
  supplier_id,
  created_by,
  submitted_date::date,
  creation_date::date,
  case
    when status_id = 0 then 'New'
    when status_id = 1 then 'Submitted'
    when status_id = 2 then 'Approved'
    when status_id = 3 then 'Closed'
  end as status_name,
  expected_date::date,
  shipping_fee,
  taxes,
  payment_date::date,
  payment_amount,
  payment_method,
  notes,
  approved_by,
  approved_date::date,
  submitted_by,
  '{{ invocation_id }}' as batch_id,
  'db' as source_data,
  current_timestamp::timestamp(0) as load_dt
from latest


{% if is_incremental() %}
  where current_timestamp > (select max(load_dt) from {{ this }})
{% endif %}
