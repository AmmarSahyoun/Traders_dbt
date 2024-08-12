
## Raw layer represented by Database (Northwind)

This sub directory contains Northwind database scripts to set up in PostgreSQL database that will be used as a **raw layer** for the **Traders project**. It includes:

- Scripts to create the database tables.
- Scripts to populate the database tables with sample data like customers, orders, suppliers, shipping information, employees, and inventory.
- Entity relation diagram that shows tables and their cardinality relations as an OLTP system.

**Key Improvements:**

- **SQL scripts** are tailored for [PostgreSQL][post] .
- **Entity-Relationship Diagram:** Visualize the business rules in the web application.

<img src="https://github.com/AmmarSahyoun/dbt_traders/blob/main/assets/ERD-northwind.png" alt="Draft diagram" width="400" height="600">


**Additional Notes:**

- The "Northwind" database provided with Microsoft Access is an excellent tutorial schema for a small ecommerce business. It represent a relational tables for storing data from Web Application as OLTP. Credits goes to the original database source of the MySQL sample data [dalers][link].


[link]: https://github.com/dalers/mywind
[post]: https://www.postgresql.org/download/
