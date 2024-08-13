{{ config(materialized='incremental', unique_key='customer_id')}}

with ranked_src as(
select 
	*,
	row_number() over (partition by id, company, last_name, first_name order by id desc) as rnk
from {{ source('dbo','customers') }}
),


latest as(
  select
   * 
  from ranked_src where rnk = 1
)


select 
  id as customer_id, 
  company,
  last_name, 
  first_name, 
  email_address, 
  job_title, 
  business_phone, 
  home_phone, 
  mobile_phone, 
  fax_number,
  address, 
  city, 
  state_province, 
  zip_postal_code, 
  country_region, 
  web_page, 
  notes, 
  attachments,
  '{{ invocation_id }}' batch_id,
  'db' as source_data,
  current_timestamp::timestamp(0) as load_dt
from latest
where id is not null   

{% if is_incremental() %}
  where current_timestamp > (select max(load_dt) from {{this}} )
{% endif %}

