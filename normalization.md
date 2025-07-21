# Normalization Explanation

## 1NF
- Each table has atomic values. No repeating groups.

## 2NF
- All non-key attributes are fully dependent on the primary key.
- For example, in the `Booking` table, `total_price` is fully dependent on both `property_id` and `user_id`.

## 3NF
- No transitive dependencies.
- `Payment` info is separated from `Booking`.
- `Review` is stored separately with FK to `User` and `Property`.
