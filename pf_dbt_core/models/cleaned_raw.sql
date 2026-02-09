--
-- Model: deduplicated_raw_daily_spend
-- Purpose: Produce a deduplicated view of raw daily spend records, keeping
-- the most recently ingested row per logical record (partitioned by hash_key).
--
-- Source: `personal_finance.raw_daily_spend` (raw ingestion table)
-- Materialization: table (configured below)
-- Key transforms:
--  - Formats `time_ingested` to a human-readable timestamp with timezone label
--  - Parses `date` into a DATE and derives `day_logged`
--  - Uses `ROW_NUMBER()` over `hash_key` ordered by ingestion timestamp
--    to keep the latest record per logical entity
-- Notes:
--  - Ensure `hash_key` is present and consistently generated upstream.
--  - This model assumes `time_ingested` values are stored as strings
--    parseable by `TIMESTAMP()`; adjust parsing if schema changes.
-- Owner: personal_fin project
-- Tests: add uniqueness and not_null tests for `hash_key` and `unique_id` in
--        the corresponding `schema.yml` if desired.
--

{{ config(materialized='table') }}

WITH ranked AS (
    SELECT
        hash_key, -- unique key

        time_ingested AS timestamp_ingested_raw,
        -- Time only
        FORMAT_TIMESTAMP('%H:%M:%S PHT', TIMESTAMP(time_ingested)) AS time_ingested,
        -- Date only
        FORMAT_TIMESTAMP('%d-%m-%Y', TIMESTAMP(time_ingested)) AS date_ingested,

        date AS timestamp_logged_raw,

        DATE(PARSE_DATETIME('%m/%d/%Y %H:%M:%S', date)) AS date_logged,

        FORMAT_DATETIME('%H:%M:%S', PARSE_DATETIME('%m/%d/%Y %H:%M:%S', date)) AS time_logged,

        lineitem,
        total_cost,
        payment_type,
        type,
        subtype,

        ROW_NUMBER() OVER (
            PARTITION BY hash_key
            ORDER BY TIMESTAMP(time_ingested) DESC
        ) AS ingest_row_num

    FROM {{ref('raw_daily_spend')}}
)
SELECT *
FROM ranked
WHERE row_num = 1
