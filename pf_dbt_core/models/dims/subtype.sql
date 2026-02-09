
{{config(materialized = 'view')}}


SELECT DISTINCT
    subtype,
    INITCAP(subtype) AS standardized_subtype
FROM {{ref('cleaned_raw')}}
