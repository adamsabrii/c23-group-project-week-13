WITH dupes AS (
    SELECT id AS dup_id, person_id, amount_original, expense_date,
           ROW_NUMBER() OVER (PARTITION BY currency_original, amount_original, DATE_TRUNC('day', expense_date) ORDER BY id) AS rn
    FROM expenses
)
DELETE FROM expenses
WHERE id IN (
    SELECT dup_id
    FROM dupes
    WHERE rn > 1
);