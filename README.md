# Traders
- A modern data warehouse derived from a web-platform [relational database][database_src].
- This tutorial project implemented locally using WSL ubuntu and postgresql as a dev-layer.
- The postgresql database "Traders" holds several schemas layers 'dataset' for the source database and for the target data warehouse.
- Some small tables from the source database have been replaced with seed constant data and others have been denormalized.
- Pre-commit sqlfluff rules implemented to align sql with postgres standard syntax.

<img src="https://github.com/AmmarSahyoun/dbt_traders/blob/main/assets/architecture.png" alt="Draft diagram" width="800" height="400">

## Traders Data warehouse layers
1. Source [relational database][database_src].
2. Staging layer contains dbt denormalized view models 'stg_'
3. Vault layer, a data vault modelling is implemented'vlt_'

<img src="https://github.com/AmmarSahyoun/dbt_traders/blob/main/assets/v_order_customer.png" alt="Draft diagram" width="400" height="400">

4. Semantic layer, fact and dimension tables representing a star schema models 'sem_'
<img src="https://github.com/AmmarSahyoun/dbt_traders/blob/main/assets/starSchema.png" alt="Draft diagram" width="400" height="400">


### Additional notes:
- When working with big data, it's crucial to utilize distributed computing storage with columnar reading capabilities, such as BigQuery or Synapse, to leverage partitioning for enhanced performance, reduced query latency, and cost optimization.

 
### Advantages of Data Warehouse:
- Scalability: They can handle massive amounts of data.
- Performance: Fast BI reports and complex analysis.
- Consistency: Ensures data consistency across the organization.
- Flexibility: Data warehouses can be adapted to changing business needs.

### Useful commands:
```shell
poetry shell 
```
```shell
poetry run pre-commit run sqlfluff-fix --files /RELATIVE_PATH
```

[database_src]: https://github.com/AmmarSahyoun/dbt_traders/tree/main/database_src

