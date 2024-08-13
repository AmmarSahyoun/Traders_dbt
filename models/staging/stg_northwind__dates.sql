with date_period as (
  select generate_series('2014-01-01'::date, '2030-12-31'::Date, '1 day')::date as full_date
),

dates as (
select 
    row_number() over() as date_id,
    full_date,
    extract(year from full_date) as year,
    extract(week from full_date) as year_week,
    extract(DOY from full_date) as year_day,
    case
        when extract(month from full_date) >= 4 then extract(year from full_date)
        else extract(year from full_date) - 1
    end as fiscal_year,
    case
        when extract(month from full_date) between 4 and 6 then 'Q1'
        when extract(month from full_date) between 7 and 9 then 'Q2'
        when extract(month from full_date) between 10 and 12 then 'Q3'
        else 'Q4'
    end as fiscal_qrt,
    extract(month from full_date) as month,
    to_char(full_date, 'month') as month_name,
    extract(isodow from full_date) as week_day,
    to_char(full_date, 'Day') as day_name,
    case
        when extract(isodow from full_date) between 1 and 5 then true 
        else false
    end as is_weekday
from date_period
)

select 
    *,
    '{{ invocation_id }}' as batch_id,
    'dbt_Gen' as source_data,
    current_timestamp::timestamp(0) as load_dt
from dates