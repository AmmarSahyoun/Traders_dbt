{{ config(materialized='incremental', unique_key = 'employee_id') }} 

with ranked_src as (
  select
    *,
    row_number() over (partition by id, company, last_name, first_name order by id desc) as rnk
  from {{ source('dbo','employees') }}
),


latest as (
  select *
  from ranked_src where rnk = 1
),


privleged as (
  select
    l.id as employee_id,
    l.company,
    l.last_name,
    l.first_name,
    l.email_address,
    l.job_title,
    l.business_phone,
    l.home_phone,
    l.mobile_phone,
    l.fax_number,
    l.address,
    l.city,
    l.state_province,
    l.zip_postal_code,
    l.country_region,
    l.web_page,
    l.notes,
    l.attachments,
    p.privilege_name
  from latest as l
  left join {{ ref('constant_seed__employee_privilieges') }} as ep
  on l.id = ep.employee_id
  left join {{ ref('constant_seed__privileges') }} as p
  on ep.privilege_id = p.id
  where l.id is not null
)


select
  *,
  '{{ invocation_id }}' as batch_id,
  'db' as source_data,
  current_timestamp::timestamp(0) as load_dt
from privleged


{% if is_incremental() %}
  where current_timestamp > (select max(load_dt) from {{ this }})
{% endif %}
