
SELECT
    payment_type,
    CASE
        WHEN LOWER(payment_type) LIKE 'mari%' THEN 'Maribank'
        WHEN LOWER(payment_type) LIKE 'cash' THEN 'Cash'
        WHEN LOWER(payment_type) LIKE 'gcash' THEN 'Gcash'
        WHEN LOWER(payment_type) LIKE 'gotyme' THEN 'GoTyme'
        ELSE 'Other'
    END AS standardized_payment_type
FROM {{ref('cleaned_raw')}}
GROUP BY 1,2
