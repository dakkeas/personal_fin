
{{config(materialized = 'view')}}

SELECT DISTINCT
    lineitem AS lineitem_key,
    INITCAP(lineitem) AS lineitem_cleaned
FROM {{ref('cleaned_raw')}}