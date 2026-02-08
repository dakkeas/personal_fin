# models/bq

This folder contains BigQuery SQL models related to daily spend ingestion and
enrichment for the `personal_fin` project.

- `deduplicated_raw_daily_spend.sql` — keeps the most-recently ingested row
  per logical record (partitioned by `hash_key`) from the raw ingestion table
  `personal_finance.raw_daily_spend`.

Notes:
- If upstream ingestion changes, update parsing logic and this README.
- Add dbt `schema.yml` tests alongside models for stronger validation.
