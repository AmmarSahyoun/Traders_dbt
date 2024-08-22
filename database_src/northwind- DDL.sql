-- DLL commands for postgresql

-- create "Traders" DATABasE

create database Traders; 
drop schema if exists dbo;
create schema if not exists dbo;
set search_path to dbo;


-- -----------------------------------------------------
-- table customers
-- -----------------------------------------------------
create table if not exists dbo.customers (
    id SERIAL primary key,
    company varchar(50) default null,
    last_name varchar(50) default null,
    first_name varchar(50) default null,
    email_address varchar(50) default null,
    job_title varchar(50) default null,
    business_phone varchar(25) default null,
    home_phone varchar(25) default null,
    mobile_phone varchar(25) default null,
    fax_number varchar(25) default null,
    address TEXT default null,
    city varchar(50) default null,
    state_province varchar(50) default null,
    zip_postal_code varchar(15) default null,
    country_region varchar(50) default null,
    web_page TEXT default null,
    notes TEXT default null,
    attachments BYTEA default null
);

create index city_idx on dbo.customers (city);
create index company_idx on dbo.customers (company);
create index first_name_idx on dbo.customers (first_name);
create index last_name_idx on dbo.customers (last_name);
create index zip_postal_code_idx on dbo.customers (zip_postal_code);
create index state_province_idx on dbo.customers (state_province);


-- -----------------------------------------------------
-- table employees
-- -----------------------------------------------------
create table if not exists dbo.employees (
    id SERIAL primary key,
    company varchar(50) default null,
    last_name varchar(50) default null,
    first_name varchar(50) default null,
    email_address varchar(50) default null,
    job_title varchar(50) default null,
    business_phone varchar(25) default null,
    home_phone varchar(25) default null,
    mobile_phone varchar(25) default null,
    fax_number varchar(25) default null,
    address TEXT default null,
    city varchar(50) default null,
    state_province varchar(50) default null,
    zip_postal_code varchar(15) default null,
    country_region varchar(50) default null,
    web_page TEXT default null,
    notes TEXT default null,
    attachments BYTEA default null
);


-- -----------------------------------------------------
-- table privileges
-- -----------------------------------------------------
create table if not exists dbo.privileges (
    id SERIAL primary key,
    privilege_name varchar(50) default null
);


-- -----------------------------------------------------
-- table employee_privileges
-- -----------------------------------------------------
create table if not exists dbo.employee_privileges (
    employee_id INT not null,
    privilege_id INT not null,
    primary key (employee_id, privilege_id),
    constraint fk_employee_privileges_employees1
        foreign key (employee_id)
        references dbo.employees (id)
        on delete no action
        on update no action,
    constraint fk_employee_privileges_privileges1
        foreign key (privilege_id)
        references dbo.privileges (id)
        on delete no action
        on update no action
);

create index employee_id_idx on dbo.employee_privileges (employee_id);
create index privilege_id_idx on dbo.employee_privileges (privilege_id);


-- -----------------------------------------------------
-- table inventory_transaction_types
-- -----------------------------------------------------
create table if not exists dbo.inventory_transaction_types (
    id SMALLINT not null,
    type_name varchar(50) not null,
    primary key (id)
);


-- -----------------------------------------------------
-- table shippers
-- -----------------------------------------------------
create table if not exists dbo.shippers (
    id SERIAL primary key,
    company varchar(50) default null,
    last_name varchar(50) default null,
    first_name varchar(50) default null,
    email_address varchar(50) default null,
    job_title varchar(50) default null,
    business_phone varchar(25) default null,
    home_phone varchar(25) default null,
    mobile_phone varchar(25) default null,
    fax_number varchar(25) default null,
    address TEXT default null,
    city varchar(50) default null,
    state_province varchar(50) default null,
    zip_postal_code varchar(15) default null,
    country_region varchar(50) default null,
    web_page TEXT default null,
    notes TEXT default null,
    attachments BYTEA default null
);


-- -----------------------------------------------------
-- table orders_tax_status
-- -----------------------------------------------------
create table if not exists dbo.orders_tax_status (
    id SMALLINT not null,
    tax_status_name varchar(50) not null,
    primary key (id)
);


-- -----------------------------------------------------
-- table orders_status
-- -----------------------------------------------------
create table if not exists dbo.orders_status (
    id SMALLINT not null,
    status_name varchar(50) not null,
    primary key (id)
);


-- -----------------------------------------------------
-- table orders
-- -----------------------------------------------------
create table if not exists dbo.orders (
    id SERIAL primary key,
    employee_id INT default null,
    customer_id INT default null,
    order_date TIMESTAMP default null,
    shipped_date TIMESTAMP default null,
    shipper_id INT default null,
    ship_name varchar(50) default null,
    ship_address TEXT default null,
    ship_city varchar(50) default null,
    ship_state_province varchar(50) default null,
    ship_zip_postal_code varchar(50) default null,
    ship_country_region varchar(50) default null,
    shipping_fee DECIMAL(19,4) default 0.0000,
    taxes DECIMAL(19,4) default 0.0000,
    payment_type varchar(50) default null,
    paid_date TIMESTAMP default null,
    notes TEXT default null,
    tax_rate DOUBLE PRECISIon default 0,
    tax_status_id SMALLINT default null,
    status_id SMALLINT default 0,
    constraint fk_orders_customers foreign key (customer_id)
        references dbo.customers (id)
        on delete no action on update no action,
    constraint fk_orders_employees1 foreign key (employee_id)
        references dbo.employees (id)
        on delete no action on update no action,
    constraint fk_orders_shippers1 foreign key (shipper_id)
        references dbo.shippers (id)
        on delete no action on update no action,
    constraint fk_orders_orders_tax_status1 foreign key (tax_status_id)
        references dbo.orders_tax_status (id)
        on delete no action on update no action,
    constraint fk_orders_orders_status1 foreign key (status_id)
        references dbo.orders_status (id)
        on delete no action on update no action
);

create index customer_id_idx on dbo.orders (customer_id);
create index shipper_id_idx on dbo.orders (shipper_id);
create index tax_status_idx on dbo.orders (tax_status_id);
create index ship_zip_postal_code_idx on dbo.orders (ship_zip_postal_code);



-- -----------------------------------------------------
-- table products
-- -----------------------------------------------------
create table if not exists dbo.products (
    supplier_ids TEXT default null,
    id SERIAL primary key,
    product_code varchar(25) default null,
    product_name varchar(50) default null,
    description TEXT default null,
    standard_cost DECIMAL(19,4) default 0.0000,
    list_price DECIMAL(19,4) not null default 0.0000,
    reorder_level INT default null,
    target_level INT default null,
    quantity_per_unit varchar(50) default null,
    discontinued BOOLEAN not null default false,
    minimum_reorder_quantity INT default null,
    category varchar(50) default null,
    attachments BYTEA default null
);

create index product_code_idx on dbo.products (product_code);



-- -----------------------------------------------------
-- table purchase_order_status
-- -----------------------------------------------------
create table if not exists dbo.purchase_order_status (
    id INT not null,
    status varchar(50) default null,
    primary key (id)
);



-- -----------------------------------------------------
-- table suppliers
-- -----------------------------------------------------
create table if not exists dbo.suppliers (
    id SERIAL primary key,
    company varchar(50) default null,
    last_name varchar(50) default null,
    first_name varchar(50) default null,
    email_address varchar(50) default null,
    job_title varchar(50) default null,
    business_phone varchar(25) default null,
    home_phone varchar(25) default null,
    mobile_phone varchar(25) default null,
    fax_number varchar(25) default null,
    address TEXT default null,
    city varchar(50) default null,
    state_province varchar(50) default null,
    zip_postal_code varchar(15) default null,
    country_region varchar(50) default null,
    web_page TEXT default null,
    notes TEXT default null,
    attachments BYTEA default null
);


-- -----------------------------------------------------
-- table purchase_orders
-- -----------------------------------------------------
create table if not exists dbo.purchase_orders (
    id SERIAL primary key,
    supplier_id INT default null,
    created_by INT default null,
    submitted_date TIMESTAMP default null,
    creation_date TIMESTAMP default null,
    status_id INT default 0,
    expected_date TIMESTAMP default null,
    shipping_fee DECIMAL(19,4) not null default 0.0000,
    taxes DECIMAL(19,4) not null default 0.0000,
    payment_date TIMESTAMP default null,
    payment_amount DECIMAL(19,4) default 0.0000,
    payment_method varchar(50) default null,
    notes TEXT default null,
    approved_by INT default null,
    approved_date TIMESTAMP default null,
    submitted_by INT default null,
    constraint fk_purchase_orders_employees1 foreign key (created_by)
        references dbo.employees (id)
        on delete no action on update no action,
    constraint fk_purchase_orders_purchase_order_status1 foreign key (status_id)
        references dbo.purchase_order_status (id)
        on delete no action on update no action,
    constraint fk_purchase_orders_suppliers1 foreign key (supplier_id)
        references dbo.suppliers (id)
        on delete no action on update no action
);

create unique index id_idx on dbo.purchase_orders (id);
create index created_by_idx on dbo.purchase_orders (created_by);
create index status_id_idx on dbo.purchase_orders (status_id);
create index supplier_id_idx on dbo.purchase_orders (supplier_id);



-- -----------------------------------------------------
-- table inventory_transactions
-- -----------------------------------------------------
create table if not exists dbo.inventory_transactions (
    id SERIAL primary key,
    transaction_type SMALLINT not null,
    transaction_created_date TIMESTAMP default null,
    transaction_modified_date TIMESTAMP default null,
    product_id INT not null,
    quantity INT not null,
    purchase_order_id INT default null,
    customer_order_id INT default null,
    comments varchar(255) default null,
    constraint fk_inventory_transactions_orders1 foreign key (customer_order_id)
        references dbo.orders (id)
        on delete no action on update no action,
    constraint fk_inventory_transactions_products1 foreign key (product_id)
        references dbo.products (id)
        on delete no action on update no action,
    constraint fk_inventory_transactions_purchase_orders1 foreign key (purchase_order_id)
        references dbo.purchase_orders (id)
        on delete no action on update no action,
    constraint fk_inventory_transactions_inventory_transaction_types1 foreign key (transaction_type)
        references dbo.inventory_transaction_types (id)
        on delete no action on update no action
);

create index customer_order_id_idx on dbo.inventory_transactions (customer_order_id);
create index product_id_idx on dbo.inventory_transactions (product_id);
create index purchase_order_id_idx on dbo.inventory_transactions (purchase_order_id);
create index transaction_type_idx on dbo.inventory_transactions (transaction_type);



-- -----------------------------------------------------
-- table invoices
-- -----------------------------------------------------
create table if not exists dbo.invoices (
    id SERIAL primary key,
    order_id INT default null,
    invoice_date TIMESTAMP default null,
    due_date TIMESTAMP default null,
    tax DECIMAL(19,4) default 0.0000,
    shipping DECIMAL(19,4) default 0.0000,
    amount_due DECIMAL(19,4) default 0.0000,
    constraint fk_invoices_orders1 foreign key (order_id)
        references dbo.orders (id)
        on delete no action on update no action
);

create index order_id_idx on dbo.invoices (order_id);
create index fk_invoices_orders1_idx on dbo.invoices (order_id);

-- -----------------------------------------------------
-- table order_details_status
-- -----------------------------------------------------
create table if not exists dbo.order_details_status (
    id INT not null,
    status_name varchar(50) not null,
    primary key (id)
);

-- -----------------------------------------------------
-- table order_details
-- -----------------------------------------------------
create table if not exists dbo.order_details (
    id SERIAL primary key,
    order_id INT not null,
    product_id INT default null,
    quantity DECIMAL(18,4) not null default 0.0000,
    unit_price DECIMAL(19,4) default 0.0000,
    discount DOUBLE PRECISIon not null default 0,
    status_id INT default null,
    date_allocated TIMESTAMP default null,
    purchase_order_id INT default null,
    inventory_id INT default null,
    constraint fk_order_details_orders1 foreign key (order_id)
        references dbo.orders (id)
        on delete no action on update no action,
    constraint fk_order_details_products1 foreign key (product_id)
        references dbo.products (id)
        on delete no action on update no action,
    constraint fk_order_details_order_details_status1 foreign key (status_id)
        references dbo.order_details_status (id)
        on delete no action on update no action
);

create index inventory_id_idx on dbo.order_details (inventory_id);


-- -----------------------------------------------------
-- table purchase_order_details
-- -----------------------------------------------------
create table if not exists dbo.purchase_order_details (
    id SERIAL primary key,
    purchase_order_id INT not null,
    product_id INT default null,
    quantity DECIMAL(18,4) not null,
    unit_cost DECIMAL(19,4) not null,
    date_received TIMESTAMP default null,
    posted_to_inventory BOOLEAN not null default false,
    inventory_id INT default null,
    constraint fk_purchase_order_details_inventory_transactions1 foreign key (inventory_id)
        references dbo.inventory_transactions (id)
        on delete no action on update no action,
    constraint fk_purchase_order_details_products1 foreign key (product_id)
        references dbo.products (id)
        on delete no action on update no action,
    constraint fk_purchase_order_details_purchase_orders1 foreign key (purchase_order_id)
        references dbo.purchase_orders (id)
        on delete no action on update no action
);


-- -----------------------------------------------------
-- table sales_reports
-- -----------------------------------------------------
create table if not exists dbo.sales_reports (
    group_by varchar(50) not null,
    display varchar(50) default null,
    title varchar(50) default null,
    filter_row_source TEXT default null,
    is_default BOOLEAN not null default false,
    primary key (group_by)
);


-- -----------------------------------------------------
-- table strings
-- -----------------------------------------------------
create table if not exists dbo.strings (
    string_id SERIAL primary key,
    string_data varchar(255) default null
);

-- -----------------------------------------------------
-- list all 20 tables
-- -----------------------------------------------------
select * from pg_catalog.pg_tables pt where schemaname = 'dbo';