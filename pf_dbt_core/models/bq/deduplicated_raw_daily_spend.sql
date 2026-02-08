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
        unique_id,

        FORMAT_TIMESTAMP(
          '%H:%M:%S %d-%m-%Y',
          TIMESTAMP(time_ingested)
        ) || ' PHT' AS time_ingested,

        PARSE_DATE('%m/%d/%Y', date) AS time_logged,

        CASE EXTRACT(DAYOFWEEK FROM PARSE_DATE('%m/%d/%Y', date))
            WHEN 1 THEN 'Sunday'
            WHEN 2 THEN 'Monday'
            WHEN 3 THEN 'Tuesday'
            WHEN 4 THEN 'Wednesday'
            WHEN 5 THEN 'Thursday'
            WHEN 6 THEN 'Friday'
            WHEN 7 THEN 'Saturday'
        END AS day_logged,

        lineitem,
        total_cost,
        payment_type,
        type,
        subtype,

        ROW_NUMBER() OVER (
            PARTITION BY hash_key
            ORDER BY TIMESTAMP(time_ingested) DESC
        ) AS row_num

    FROM `project-23eb5c74-4a49-46c1-a0e.personal_finance.raw_daily_spend`
)

SELECT *
FROM ranked
WHERE row_num = 1
