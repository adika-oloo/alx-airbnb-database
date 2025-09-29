-- ============================
-- Create Indexes for Optimization
-- ============================

-- Users table: frequently queried by email
CREATE INDEX idx_users_email ON users(email);

-- Bookings table: often filtered/joined by user_id, property_id, and ordered by created_at
CREATE INDEX idx_bookings_user_id ON bookings(user_id);
CREATE INDEX idx_bookings_property_id ON bookings(property_id);
CREATE INDEX idx_bookings_created_at ON bookings(created_at);

-- Properties table: often searched by name and location
CREATE INDEX idx_properties_name ON properties(name);
CREATE INDEX idx_properties_location ON properties(location);

-- Composite index for property + date queries
CREATE INDEX idx_bookings_property_date ON bookings(property_id, created_at);

-- ============================
-- Performance Measurement
-- ============================

-- Check performance of querying bookings by user_id
EXPLAIN SELECT * FROM bookings WHERE user_id = 5;
EXPLAIN ANALYZE SELECT * FROM bookings WHERE user_id = 5;

-- Check performance of querying properties by location
EXPLAIN SELECT * FROM properties WHERE location = 'Nairobi';
EXPLAIN ANALYZE SELECT * FROM properties WHERE location = 'Nairobi';

-- Check performance of querying bookings by property and date
EXPLAIN SELECT * FROM bookings WHERE property_id = 10 AND created_at > '2025-01-01';
EXPLAIN ANALYZE SELECT * FROM bookings WHERE property_id = 10 AND created_at > '2025-01-01';
