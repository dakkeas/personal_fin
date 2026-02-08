# models/bq

This folder contains BigQuery SQL models related to daily spend ingestion and
enrichment for the `personal_fin` project.

- `deduplicated_raw_daily_spend.sql` — keeps the most-recently ingested row
  per logical record (partitioned by `hash_key`) from the raw ingestion table
  `personal_finance.raw_daily_spend`.

Documentation & tests:

- A `schema.yml` is provided next to the model to declare column descriptions
  and basic tests (not_null / unique) for key fields. See
  `schema.yml` for details.

How to validate locally:

```bash
# Run only this model
dbt run --models +deduplicated_raw_daily_spend

# Run tests declared in schema.yml for the model
dbt test --models deduplicated_raw_daily_spend

# Generate and serve docs (optional)
dbt docs generate
dbt docs serve
```

Notes:
- If upstream ingestion changes, update parsing logic in the model and the
  descriptions in `schema.yml`.
