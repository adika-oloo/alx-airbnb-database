-- ============================
-- Index creation for optimization
-- ============================

-- Users table
CREATE INDEX idx_users_email ON users(email);

-- Bookings table
CREATE INDEX idx_bookings_user_id ON bookings(user_id);
CREATE INDEX idx_bookings_property_id ON bookings(property_id);
CREATE INDEX idx_bookings_created_at ON bookings(created_at);

-- Properties table
CREATE INDEX idx_properties_name ON properties(name);
CREATE INDEX idx_properties_location ON properties(location);

-- Optional composite index if queries often filter by property and date
CREATE INDEX idx_bookings_property_date ON bookings(property_id, created_at);

-- ============================
-- Performance checks (before and after indexes)
-- ============================

-- Example: Check performance of querying bookings by user_id
EXPLAIN SELECT * FROM bookings WHERE user_id = 5;

EXPLAIN ANALYZE SELECT * FROM bookings WHERE user_id = 5;

-- Example: Check performance of querying properties by location
EXPLAIN SELECT * FROM properties WHERE location = 'Nairobi';

EXPLAIN ANALYZE SELECT * FROM properties WHERE location = 'Nairobi';

-- Example: Check performance of querying bookings by property and date
EXPLAIN SELECT * FROM bookings WHERE property_id = 10 AND created_at > '2025-01-01';

EXPLAIN ANALYZE SELECT * FROM bookings WHERE property_id = 10 AND created_at > '2025-01-01';
