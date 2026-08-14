# OCN Senior BI Engineer Case Study

Production-oriented dbt project built for the OneCarNow Senior BI Engineer case study.

The project transforms fragmented operational data into a governed analytical layer for Fleet, Operations, Collections, Finance and Leadership.

## Business objective

The analytical solution is designed to support daily decision-making across four main areas:

- Fleet health and vehicle productivity
- Operational readiness and lifecycle velocity
- Collections risk and early-warning detection
- Inventory efficiency and turnover

The model supports vehicle-level diagnostics, historical daily KPIs and dashboard-ready aggregates.

## Technology stack

- Python 3.12
- dbt Core 1.12
- dbt-databricks 1.12
- Databricks SQL
- Unity Catalog
- `dbt_utils`
- `codegen`

## Databricks architecture

The project uses the following Databricks catalog and schemas:

| Layer | Catalog | Schema | Materialization |
|---|---|---|---|
| Sources | `ocn_project` | `sources` | External source tables |
| Staging | `ocn_project` | Environment-specific staging schema | View |
| Intermediate | `ocn_project` | Environment-specific intermediate schema | View |
| Marts | `ocn_project` | Environment-specific marts schema | Table |

The exact schema names may include the active dbt target prefix, such as:

```text
production_staging
production_intermediate
production_marts
```

### Model Graph
<img width="1865" height="744" alt="dbt-dag" src="https://github.com/user-attachments/assets/f0ae7ca4-48a1-48b2-8c5e-8853a284b2a2" />
