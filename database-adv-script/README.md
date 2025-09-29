# Subqueries Practice

This task demonstrates both **non-correlated** and **correlated subqueries** in SQL.

---

## 1. Properties with Average Rating > 4.0
We use a **non-correlated subquery**:
```sql
SELECT p.id, p.name, p.location
FROM properties p
WHERE p.id IN (
    SELECT r.property_id
    FROM reviews r
    GROUP BY r.property_id
    HAVING AVG(r.rating) > 4.0
);

