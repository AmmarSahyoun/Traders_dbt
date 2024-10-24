with joined_data as (
    select
        f_order_main.f_order_main_key,
        f_order_main.order_main_id,
        f_order_main.d_shipper_key,
        f_order_main.d_customer_key,
        f_order_main.d_employee_key,
        f_order_main.order_date,
        f_order_main.order_status,
        f_order_main.payment_type,
        f_order_main.tax_status_name,
        f_order_main.taxes,
        f_order_main.tax_rate,
        f_order_main.md_source,
        f_order_main.md_batch,
        f_order_main.md_load_dt,
        customer.country,
        customer.city,
        customer.address,
        customer.zip_code
    from {{ ref('sem__f_order_main') }} AS f_order_main
    left join {{ ref('sem__d_customer_address') }}  AS customer
    on f_order_main.d_customer_key = customer.d_customer_key
),

closed AS (
    SELECT
        f_order_main_key,
        order_main_id,
        d_shipper_key,
        d_customer_key,
        d_employee_key,
        order_date,
        order_status,
        payment_type,
        tax_status_name,
        taxes,
        tax_rate,
        country,
        CAST(taxes AS numeric) * CAST(tax_rate AS numeric) AS total_tax,
        CASE 
            WHEN order_status = 'Closed' THEN 1 
            ELSE 0 
        END AS closed_order,
        md_source, 
		md_batch,
		md_load_dt
    FROM joined_data
)

SELECT * FROM closed
