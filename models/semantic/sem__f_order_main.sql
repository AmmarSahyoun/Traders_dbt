with unnest_ensemble as (
    select
        (h_order_customer->>'h_order_main_key')::bigint as f_order_main_key,
        h_order_customer->>'order_main_id' as order_main_id,
        (l_order_customer->>'h_shipper_key')::bigint as d_shipper_key,
        (l_order_customer->>'h_customer_key')::bigint as d_customer_key,
        (l_order_customer->>'h_employee_key')::bigint as d_employee_key,
		s_order_customer->>'order_date' as order_date ,
		s_order_customer->>'order_status' as order_status,
		s_order_customer->>'payment_type' as payment_type,
		s_order_customer->>'paid_date' as paid_date,
		s_order_customer->>'tax_status_name' as tax_status_name,
		s_order_customer->>'taxes' as taxes,
		s_order_customer->>'tax_rate' as tax_rate,
        'Vault' as md_source,
        md_batch,
        md_load_dt
    from e_vault.vlt__e_order_main
),

fact_table as (
    select
        f_order_main_key,
        order_main_id,
        d_shipper_key,
		h_shipper.shipper_id,
        d_customer_key,
		h_customer.customer_id,
        d_employee_key,
		h_employee.employee_id,
		order_date,
		order_status,
		payment_type,
		paid_date,
		tax_status_name,
		taxes,
		tax_rate,
        unnest_ensemble.md_source,
        unnest_ensemble.md_batch,
        unnest_ensemble.md_load_dt
    from unnest_ensemble
    left join e_vault.vlt__h_shipper_main h_shipper
      on unnest_ensemble.d_shipper_key = h_shipper.h_shipper_key
    left join e_vault.vlt__h_customer_main h_customer
      on unnest_ensemble.d_customer_key = h_customer.h_customer_key
    left join e_vault.vlt__h_employee_main h_employee
      on unnest_ensemble.d_employee_key = h_employee.h_employee_key
)
select * from fact_table