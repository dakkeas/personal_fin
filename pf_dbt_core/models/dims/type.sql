{{ config(materialized = 'view')}}



SELECT DISTINCT
    type AS type_key,
    CASE
        WHEN LOWER(category) LIKE 'transpo%' THEN 'Transportation'
        WHEN LOWER(category) LIKE 'uni%' THEN 'University'
        WHEN LOWER(category) LIKE 'health%' THEN 'Health'
        WHEN LOWER(category) LIKE 'food%' THEN 'Food'
        WHEN LOWER(category) LIKE 'misc%' THEN 'Misc'
    ELSE 'Other'
    END AS standardized_type

FROM {{ref('cleaned_raw')}}


