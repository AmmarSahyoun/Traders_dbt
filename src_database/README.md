
## Raw layer represented by Database (Northwind)

This sub directory contains Northwind database scripts to set up in PostgreSQL database that will be used as a **raw layer** for the **Traders project**. It includes:

- Scripts to create the database tables.
- Scripts to populate the database tables with sample data like customers, orders, suppliers, shipping information, employees, and inventory.
- Entity relation diagram that shows tables and their cardinality relations as an OLTP system.

**Key Improvements:**

- **Emphasis on PostgreSQL:** It explicitly states that the scripts are tailored for [PostgreSQL][post] .
- **ERD diagram:** Mentions the inclusion of an ERD (Entity-Relationship Diagram) for better schema visualization.


**Additional Notes:**

- The "Northwind" database provided with Microsoft Access is an excellent tutorial schema for a small ecommerce business. It represent a relational tables for storing data from Web Application as OLTP. **Credits** goes to the original database source of the MySQL sample data [dalers][link].
- for working with big data we need to use distributed computing storage with a columnar reading capability like BigQuery or Synapse to leverage of partitioning in reduce query cost and for better performance.
 

### Reason to build DW:
-Fast BI reports loaded with latency time 
-compliance to security guidelines by applying business rules



[link]: https://github.com/dalers/mywind
[post]: https://www.postgresql.org/download/
