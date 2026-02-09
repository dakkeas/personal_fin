{{ config(materialized = 'view') }}

SELECT DISTINCT
    date_logged AS date_logged_key,
    EXTRACT(DAYOFWEEK FROM date_logged) AS day_num,
    CASE EXTRACT(DAYOFWEEK FROM date_logged)
        WHEN 1 THEN 'Sunday'
        WHEN 2 THEN 'Monday'
        WHEN 3 THEN 'Tuesday'
        WHEN 4 THEN 'Wednesday'
        WHEN 5 THEN 'Thursday'
        WHEN 6 THEN 'Friday'
        WHEN 7 THEN 'Saturday'
    END AS day_name,
    EXTRACT(MONTH FROM date_logged) AS month_num,
    CASE EXTRACT(MONTH FROM date_logged)
        WHEN 1 THEN 'January'
        WHEN 2 THEN 'February'
        WHEN 3 THEN 'March'
        WHEN 4 THEN 'April'
        WHEN 5 THEN 'May'
        WHEN 6 THEN 'June'
        WHEN 7 THEN 'July'
        WHEN 8 THEN 'August'
        WHEN 9 THEN 'September'
        WHEN 10 THEN 'October'
        WHEN 11 THEN 'November'
        WHEN 12 THEN 'December'
    END AS month_name,

    EXTRACT(YEAR FROM date_logged) AS year_num
FROM {{ ref('cleaned_raw') }}
ORDER BY date_logged
