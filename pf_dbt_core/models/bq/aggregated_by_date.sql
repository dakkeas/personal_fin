{{config(materialized = 'table')}}


SELECT
    time_logged,
    day_logged,
    type AS TYPE_OF_SPEND,
    SUM(total_cost) AS TOTAL_SPENT
FROM {{ref('deduplicated_raw_daily_spend')}}
GROUP BY time_logged, day_logged, type
ORDER BY time_logged ASC, TOTAL_SPENT DESC



    