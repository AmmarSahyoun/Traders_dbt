with ranked_src as (
  select
    *,
    row_number() over (partition by id, employee_id, customer_id order by id asc, order_date asc, shipped_date desc) as rnk
  from {{ source('dbo','orders') }}
),


latest as (
  select *
  from ranked_src where rnk = 1
)


select
  id as order_id,
  employee_id,
  customer_id,
  order_date,
  shipped_date,
  shipper_id,
  ship_name,
  ship_address,
  ship_city,
  ship_state_province,
  ship_zip_postal_code,
  ship_country_region,
  shipping_fee,
  taxes,
  payment_type,
  paid_date,
  notes,
  case
    when tax_status_id is null then 'unknown'
    when tax_status_id = 1 then 'Taxable'
    when tax_status_id = 0 then 'Tax Exempt'
  end as tax_status_name,
  tax_rate,

  case
    when status_id = 0 then 'New'
    when status_id = 1 then 'Invoiced'
    when status_id = 2 then 'Shipped'
    when status_id = 3 then 'Closed'
  end as status_name,
  '{{ invocation_id }}' as batch_id,
  'db' as source_data,
  load_dt as load_dt
from latest
