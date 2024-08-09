-- DLL commands for postgresql

-- create "northwind" DATABASE

create database Traders; 
drop schema if exists northwind;
create schema if not exists northwind;
set search_path to northwind;


-- -----------------------------------------------------
-- table customers
-- -----------------------------------------------------
create table if not exists northwind.customers (
    id SERIAL primary key,
    company VARCHAR(50) default null,
    last_name VARCHAR(50) default null,
    first_name VARCHAR(50) default null,
    email_address VARCHAR(50) default null,
    job_title VARCHAR(50) default null,
    business_phone VARCHAR(25) default null,
    home_phone VARCHAR(25) default null,
    mobile_phone VARCHAR(25) default null,
    fax_number VARCHAR(25) default null,
    address TEXT default null,
    city VARCHAR(50) default null,
    state_province VARCHAR(50) default null,
    zip_postal_code VARCHAR(15) default null,
    country_region VARCHAR(50) default null,
    web_page TEXT default null,
    notes TEXT default null,
    attachments BYTEA default null
);

create index city_idx on northwind.customers (city);
create index company_idx on northwind.customers (company);
create index first_name_idx on northwind.customers (first_name);
create index last_name_idx on northwind.customers (last_name);
create index zip_postal_code_idx on northwind.customers (zip_postal_code);
create index state_province_idx on northwind.customers (state_province);


-- -----------------------------------------------------
-- table employees
-- -----------------------------------------------------
create table if not exists northwind.employees (
    id SERIAL primary key,
    company VARCHAR(50) default null,
    last_name VARCHAR(50) default null,
    first_name VARCHAR(50) default null,
    email_address VARCHAR(50) default null,
    job_title VARCHAR(50) default null,
    business_phone VARCHAR(25) default null,
    home_phone VARCHAR(25) default null,
    mobile_phone VARCHAR(25) default null,
    fax_number VARCHAR(25) default null,
    address TEXT default null,
    city VARCHAR(50) default null,
    state_province VARCHAR(50) default null,
    zip_postal_code VARCHAR(15) default null,
    country_region VARCHAR(50) default null,
    web_page TEXT default null,
    notes TEXT default null,
    attachments BYTEA default null
);


-- -----------------------------------------------------
-- table privileges
-- -----------------------------------------------------
create table if not exists northwind.privileges (
    id SERIAL primary key,
    privilege_name VARCHAR(50) default null
);


-- -----------------------------------------------------
-- table employee_privileges
-- -----------------------------------------------------
create table if not exists northwind.employee_privileges (
    employee_id INT not null,
    privilege_id INT not null,
    primary key (employee_id, privilege_id),
    constraint fk_employee_privileges_employees1
        foreign key (employee_id)
        references northwind.employees (id)
        on delete no action
        on update no action,
    constraint fk_employee_privileges_privileges1
        foreign key (privilege_id)
        references northwind.privileges (id)
        on delete no action
        on update no action
);

create index employee_id_idx on northwind.employee_privileges (employee_id);
create index privilege_id_idx on northwind.employee_privileges (privilege_id);


-- -----------------------------------------------------
-- table inventory_transaction_types
-- -----------------------------------------------------
create table if not exists northwind.inventory_transaction_types (
    id SMALLINT not null,
    type_name VARCHAR(50) not null,
    primary key (id)
);


-- -----------------------------------------------------
-- table shippers
-- -----------------------------------------------------
create table if not exists northwind.shippers (
    id SERIAL primary key,
    company VARCHAR(50) default null,
    last_name VARCHAR(50) default null,
    first_name VARCHAR(50) default null,
    email_address VARCHAR(50) default null,
    job_title VARCHAR(50) default null,
    business_phone VARCHAR(25) default null,
    home_phone VARCHAR(25) default null,
    mobile_phone VARCHAR(25) default null,
    fax_number VARCHAR(25) default null,
    address TEXT default null,
    city VARCHAR(50) default null,
    state_province VARCHAR(50) default null,
    zip_postal_code VARCHAR(15) default null,
    country_region VARCHAR(50) default null,
    web_page TEXT default null,
    notes TEXT default null,
    attachments BYTEA default null
);


-- -----------------------------------------------------
-- table orders_tax_status
-- -----------------------------------------------------
create table if not exists northwind.orders_tax_status (
    id SMALLINT not null,
    tax_status_name VARCHAR(50) not null,
    primary key (id)
);


-- -----------------------------------------------------
-- table orders_status
-- -----------------------------------------------------
create table if not exists northwind.orders_status (
    id SMALLINT not null,
    status_name VARCHAR(50) not null,
    primary key (id)
);


-- -----------------------------------------------------
-- table orders
-- -----------------------------------------------------
create table if not exists northwind.orders (
    id SERIAL primary key,
    employee_id INT default null,
    customer_id INT default null,
    order_date TIMESTAMP default null,
    shipped_date TIMESTAMP default null,
    shipper_id INT default null,
    ship_name VARCHAR(50) default null,
    ship_address TEXT default null,
    ship_city VARCHAR(50) default null,
    ship_state_province VARCHAR(50) default null,
    ship_zip_postal_code VARCHAR(50) default null,
    ship_country_region VARCHAR(50) default null,
    shipping_fee DECIMAL(19,4) default 0.0000,
    taxes DECIMAL(19,4) default 0.0000,
    payment_type VARCHAR(50) default null,
    paid_date TIMESTAMP default null,
    notes TEXT default null,
    tax_rate DOUBLE PRECISIon default 0,
    tax_status_id SMALLINT default null,
    status_id SMALLINT default 0,
    constraint fk_orders_customers foreign key (customer_id)
        references northwind.customers (id)
        on delete no action on update no action,
    constraint fk_orders_employees1 foreign key (employee_id)
        references northwind.employees (id)
        on delete no action on update no action,
    constraint fk_orders_shippers1 foreign key (shipper_id)
        references northwind.shippers (id)
        on delete no action on update no action,
    constraint fk_orders_orders_tax_status1 foreign key (tax_status_id)
        references northwind.orders_tax_status (id)
        on delete no action on update no action,
    constraint fk_orders_orders_status1 foreign key (status_id)
        references northwind.orders_status (id)
        on delete no action on update no action
);

create index customer_id_idx on northwind.orders (customer_id);
create index shipper_id_idx on northwind.orders (shipper_id);
create index tax_status_idx on northwind.orders (tax_status_id);
create index ship_zip_postal_code_idx on northwind.orders (ship_zip_postal_code);



-- -----------------------------------------------------
-- table products
-- -----------------------------------------------------
create table if not exists northwind.products (
    supplier_ids TEXT default null,
    id SERIAL primary key,
    product_code VARCHAR(25) default null,
    product_name VARCHAR(50) default null,
    description TEXT default null,
    standard_cost DECIMAL(19,4) default 0.0000,
    list_price DECIMAL(19,4) not null default 0.0000,
    reorder_level INT default null,
    target_level INT default null,
    quantity_per_unit VARCHAR(50) default null,
    discontinued BOOLEAN not null default false,
    minimum_reorder_quantity INT default null,
    category VARCHAR(50) default null,
    attachments BYTEA default null
);

create index product_code_idx on northwind.products (product_code);



-- -----------------------------------------------------
-- table purchase_order_status
-- -----------------------------------------------------
create table if not exists northwind.purchase_order_status (
    id INT not null,
    status VARCHAR(50) default null,
    primary key (id)
);



-- -----------------------------------------------------
-- table suppliers
-- -----------------------------------------------------
create table if not exists northwind.suppliers (
    id SERIAL primary key,
    company VARCHAR(50) default null,
    last_name VARCHAR(50) default null,
    first_name VARCHAR(50) default null,
    email_address VARCHAR(50) default null,
    job_title VARCHAR(50) default null,
    business_phone VARCHAR(25) default null,
    home_phone VARCHAR(25) default null,
    mobile_phone VARCHAR(25) default null,
    fax_number VARCHAR(25) default null,
    address TEXT default null,
    city VARCHAR(50) default null,
    state_province VARCHAR(50) default null,
    zip_postal_code VARCHAR(15) default null,
    country_region VARCHAR(50) default null,
    web_page TEXT default null,
    notes TEXT default null,
    attachments BYTEA default null
);


-- -----------------------------------------------------
-- table purchase_orders
-- -----------------------------------------------------
create table if not exists northwind.purchase_orders (
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
    payment_method VARCHAR(50) default null,
    notes TEXT default null,
    approved_by INT default null,
    approved_date TIMESTAMP default null,
    submitted_by INT default null,
    constraint fk_purchase_orders_employees1 foreign key (created_by)
        references northwind.employees (id)
        on delete no action on update no action,
    constraint fk_purchase_orders_purchase_order_status1 foreign key (status_id)
        references northwind.purchase_order_status (id)
        on delete no action on update no action,
    constraint fk_purchase_orders_suppliers1 foreign key (supplier_id)
        references northwind.suppliers (id)
        on delete no action on update no action
);

create unique index id_idx on northwind.purchase_orders (id);
create index created_by_idx on northwind.purchase_orders (created_by);
create index status_id_idx on northwind.purchase_orders (status_id);
create index supplier_id_idx on northwind.purchase_orders (supplier_id);



-- -----------------------------------------------------
-- table inventory_transactions
-- -----------------------------------------------------
create table if not exists northwind.inventory_transactions (
    id SERIAL primary key,
    transaction_type SMALLINT not null,
    transaction_created_date TIMESTAMP default null,
    transaction_modified_date TIMESTAMP default null,
    product_id INT not null,
    quantity INT not null,
    purchase_order_id INT default null,
    customer_order_id INT default null,
    comments VARCHAR(255) default null,
    constraint fk_inventory_transactions_orders1 foreign key (customer_order_id)
        references northwind.orders (id)
        on delete no action on update no action,
    constraint fk_inventory_transactions_products1 foreign key (product_id)
        references northwind.products (id)
        on delete no action on update no action,
    constraint fk_inventory_transactions_purchase_orders1 foreign key (purchase_order_id)
        references northwind.purchase_orders (id)
        on delete no action on update no action,
    constraint fk_inventory_transactions_inventory_transaction_types1 foreign key (transaction_type)
        references northwind.inventory_transaction_types (id)
        on delete no action on update no action
);

create index customer_order_id_idx on northwind.inventory_transactions (customer_order_id);
create index product_id_idx on northwind.inventory_transactions (product_id);
create index purchase_order_id_idx on northwind.inventory_transactions (purchase_order_id);
create index transaction_type_idx on northwind.inventory_transactions (transaction_type);



-- -----------------------------------------------------
-- table invoices
-- -----------------------------------------------------
create table if not exists northwind.invoices (
    id SERIAL primary key,
    order_id INT default null,
    invoice_date TIMESTAMP default null,
    due_date TIMESTAMP default null,
    tax DECIMAL(19,4) default 0.0000,
    shipping DECIMAL(19,4) default 0.0000,
    amount_due DECIMAL(19,4) default 0.0000,
    constraint fk_invoices_orders1 foreign key (order_id)
        references northwind.orders (id)
        on delete no action on update no action
);

create index order_id_idx on northwind.invoices (order_id);
create index fk_invoices_orders1_idx on northwind.invoices (order_id);

-- -----------------------------------------------------
-- table order_details_status
-- -----------------------------------------------------
create table if not exists northwind.order_details_status (
    id INT not null,
    status_name VARCHAR(50) not null,
    primary key (id)
);

-- -----------------------------------------------------
-- table order_details
-- -----------------------------------------------------
create table if not exists northwind.order_details (
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
        references northwind.orders (id)
        on delete no action on update no action,
    constraint fk_order_details_products1 foreign key (product_id)
        references northwind.products (id)
        on delete no action on update no action,
    constraint fk_order_details_order_details_status1 foreign key (status_id)
        references northwind.order_details_status (id)
        on delete no action on update no action
);

create index inventory_id_idx on northwind.order_details (inventory_id);


-- -----------------------------------------------------
-- table purchase_order_details
-- -----------------------------------------------------
create table if not exists northwind.purchase_order_details (
    id SERIAL primary key,
    purchase_order_id INT not null,
    product_id INT default null,
    quantity DECIMAL(18,4) not null,
    unit_cost DECIMAL(19,4) not null,
    date_received TIMESTAMP default null,
    posted_to_inventory BOOLEAN not null default false,
    inventory_id INT default null,
    constraint fk_purchase_order_details_inventory_transactions1 foreign key (inventory_id)
        references northwind.inventory_transactions (id)
        on delete no action on update no action,
    constraint fk_purchase_order_details_products1 foreign key (product_id)
        references northwind.products (id)
        on delete no action on update no action,
    constraint fk_purchase_order_details_purchase_orders1 foreign key (purchase_order_id)
        references northwind.purchase_orders (id)
        on delete no action on update no action
);


-- -----------------------------------------------------
-- table sales_reports
-- -----------------------------------------------------
create table if not exists northwind.sales_reports (
    group_by VARCHAR(50) not null,
    display VARCHAR(50) default null,
    title VARCHAR(50) default null,
    filter_row_source TEXT default null,
    is_default BOOLEAN not null default false,
    primary key (group_by)
);


-- -----------------------------------------------------
-- table strings
-- -----------------------------------------------------
create table if not exists northwind.strings (
    string_id SERIAL primary key,
    string_data VARCHAR(255) default null
);

-- -----------------------------------------------------
-- list all 20 tables
-- -----------------------------------------------------
select * from pg_catalog.pg_tables pt where schemaname = 'northwind';