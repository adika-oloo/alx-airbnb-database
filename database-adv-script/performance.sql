-- AirBnB Database Performance Optimization Script
-- Run these commands to analyze and improve query performance

-- =============================================
-- 1. QUERY PERFORMANCE ANALYSIS
-- =============================================

-- Analyze query execution plans for critical queries
EXPLAIN ANALYZE
SELECT p.property_id, p.name, p.location, p.pricepernight
FROM properties p
WHERE p.location LIKE 'New York%'
AND p.pricepernight BETWEEN 100 AND 200;

EXPLAIN ANALYZE
SELECT p.property_id, p.name, p.location, p.pricepernight
FROM properties p
WHERE NOT EXISTS (
    SELECT 1 FROM bookings b
    WHERE b.property_id = p.property_id
    AND b.status IN ('confirmed', 'pending')
    AND b.start_date <= '2023-04-15'
    AND b.end_date >= '2023-04-10'
);

EXPLAIN ANALYZE
SELECT u.first_name, u.last_name, b.start_date, b.end_date,
       p.name as property_name, p.location, b.total_price
FROM users u
JOIN bookings b ON u.user_id = b.user_id
JOIN properties p ON b.property_id = p.property_id
WHERE u.user_id = 'e5f6g7h8-5678-9012-9004-ef1234567890'
ORDER BY b.created_at DESC;

-- =============================================
-- 2. INDEX USAGE AND FRAGMENTATION ANALYSIS
-- =============================================

-- Check existing indexes and their usage statistics
SELECT 
    schemaname,
    tablename,
    indexname,
    idx_scan as index_scans,
    idx_tup_read as tuples_read,
    idx_tup_fetch as tuples_fetched
FROM pg_stat_user_indexes
WHERE schemaname = 'public'
ORDER BY idx_scan DESC;

-- Analyze index fragmentation (PostgreSQL example)
SELECT
    schemaname,
    tablename,
    indexname,
    avg_fragmentation_in_percent,
    avg_page_space_used_in_percent
FROM pg_stat_all_indexes
WHERE schemaname = 'public';

-- =============================================
-- 3. CREATE STRATEGIC INDEXES
-- =============================================

-- Property search optimization
CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_properties_location_price 
ON properties(location, pricepernight);

CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_properties_host_id 
ON properties(host_id);

-- Booking date range and status optimization
CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_bookings_dates_status 
ON bookings(start_date, end_date, status);

CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_bookings_user_id 
ON bookings(user_id);

CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_bookings_property_id 
ON bookings(property_id);

-- Review rating and recency optimization
CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_reviews_property_rating 
ON reviews(property_id, rating, created_at);

CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_reviews_user_property 
ON reviews(user_id, property_id);

-- Message conversation optimization
CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_messages_conversation 
ON messages(sender_id, recipient_id, sent_at);

CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_messages_sent_at 
ON messages(sent_at);

-- Payment date optimization
CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_payments_booking_date 
ON payments(booking_id, payment_date);

-- =============================================
-- 4. INDEX MAINTENANCE
-- =============================================

-- Rebuild heavily fragmented indexes (concurrently to avoid locking)
-- Note: REINDEX CONCURRENTLY is available in PostgreSQL 12+
REINDEX INDEX CONCURRENTLY idx_properties_location_price;
REINDEX INDEX CONCURRENTLY idx_bookings_dates_status;

-- Update table statistics for query optimizer
ANALYZE properties;
ANALYZE bookings;
ANALYZE users;
ANALYZE reviews;
ANALYZE messages;
ANALYZE payments;

-- =============================================
-- 5. PERFORMANCE MONITORING QUERIES
-- =============================================

-- Find slow queries (if query logging is enabled)
SELECT query, calls, total_time, mean_time, rows
FROM pg_stat_statements
ORDER BY mean_time DESC
LIMIT 10;

-- Check table and index sizes
SELECT
    tablename,
    pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename)) as total_size,
    pg_size_pretty(pg_relation_size(schemaname||'.'||tablename)) as table_size,
    pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename) - 
                   pg_relation_size(schemaname||'.'||tablename)) as index_size
FROM pg_tables
WHERE schemaname = 'public'
ORDER BY pg_total_relation_size(schemaname||'.'||tablename) DESC;

-- =============================================
-- 6. QUERY OPTIMIZATION EXAMPLES
-- =============================================

-- Example: Optimized property search query
-- Before: SELECT * FROM properties WHERE location LIKE '%New York%'
-- After: Specific columns and efficient filtering
SELECT property_id, name, location, pricepernight, description
FROM properties
WHERE location LIKE 'New York%'  -- Leading wildcard prevents index use
AND pricepernight BETWEEN 100 AND 200
AND property_id IN (
    SELECT property_id FROM properties 
    WHERE host_id IN (
        SELECT user_id FROM users WHERE role = 'host'
    )
);

-- Example: Optimized booking history query
SELECT u.first_name, u.last_name, b.start_date, b.end_date,
       p.name as property_name, p.location, b.total_price
FROM users u
INNER JOIN bookings b ON u.user_id = b.user_id
INNER JOIN properties p ON b.property_id = p.property_id
WHERE u.user_id = 'e5f6g7h8-5678-9012-9004-ef1234567890'
AND b.status = 'confirmed'
ORDER BY b.created_at DESC
LIMIT 20;

-- =============================================
-- 7. PERFORMANCE COMPARISON
-- =============================================

-- Run the same EXPLAIN ANALYZE queries from section 1
-- after implementing indexes to measure improvement

-- Note: Compare execution times, scan types (index scan vs seq scan),
-- and rows processed before and after optimization
