Identify High-Usage Columns

From the previous queries, the most frequently used columns in WHERE, JOIN, and ORDER BY clauses are:
| Table        | High-Usage Columns       | Reason                        |
| ------------ | ------------------------ | ----------------------------- |
| `users`      | `id`                     | Used in JOIN and WHERE        |
| `bookings`   | `user_id`, `property_id` | Used in JOIN and filtering    |
| `properties` | `id`, `name`, `rating`   | Used in JOIN, ORDER BY, WHERE |
| `reviews`    | `property_id`            | Used in JOIN                  |

Write CREATE INDEX Statements

Save the following SQL in a file called database_index.sql
-- Indexes on 'users' table
CREATE INDEX idx_users_id ON users(id);

-- Indexes on 'bookings' table
CREATE INDEX idx_bookings_user_id ON bookings(user_id);
CREATE INDEX idx_bookings_property_id ON bookings(property_id);

-- Indexes on 'properties' table
CREATE INDEX idx_properties_id ON properties(id);
CREATE INDEX idx_properties_rating ON properties(rating);
CREATE INDEX idx_properties_name ON properties(name);

-- Indexes on 'reviews' table
CREATE INDEX idx_reviews_property_id ON reviews(property_id);

Measure Performance Before and After

You can use either EXPLAIN or EXPLAIN ANALYZE (PostgreSQL) to compare execution plans and timings.
-- Before adding indexes
EXPLAIN ANALYZE
SELECT 
    p.name, COUNT(b.id) AS total_bookings
FROM 
    properties p
LEFT JOIN 
    bookings b ON p.id = b.property_id
GROUP BY 
    p.name;

-- Add indexes (run database_index.sql)

-- After adding indexes
EXPLAIN ANALYZE
SELECT 
    p.name, COUNT(b.id) AS total_bookings
FROM 
    properties p
LEFT JOIN 
    bookings b ON p.id = b.property_id
GROUP BY 
    p.name;
