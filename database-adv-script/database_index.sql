-- AirBnB Database Index Optimization Script
-- This script creates additional indexes and measures query performance

-- =============================================
-- 1. CURRENT INDEXES ANALYSIS
-- =============================================

-- First, let's see what indexes already exist
SELECT 
    tablename, 
    indexname, 
    indexdef 
FROM pg_indexes 
WHERE schemaname = 'public'
ORDER BY tablename, indexname;

-- =============================================
-- 2. ADDITIONAL INDEXES CREATION
-- =============================================

-- Indexes for better search performance on frequently queried columns

-- Composite index for property search (location + price range)
CREATE INDEX IF NOT EXISTS idx_properties_location_price 
ON properties(location, pricepernight);

-- Index for booking date range queries
CREATE INDEX IF NOT EXISTS idx_bookings_date_range 
ON bookings(start_date, end_date);

-- Composite index for user role-based queries
CREATE INDEX IF NOT EXISTS idx_users_role_email 
ON users(role, email);

-- Index for review ratings and recency
CREATE INDEX IF NOT EXISTS idx_reviews_rating_recency 
ON reviews(rating, created_at);

-- Index for message conversations between users
CREATE INDEX IF NOT EXISTS idx_messages_conversation 
ON messages(sender_id, recipient_id, sent_at);

-- Partial index for active bookings only
CREATE INDEX IF NOT EXISTS idx_bookings_active 
ON bookings(property_id, start_date) 
WHERE status IN ('pending', 'confirmed');

-- Index for payment date ranges
CREATE INDEX IF NOT EXISTS idx_payments_date 
ON payments(payment_date);

-- =============================================
-- 3. PERFORMANCE MEASUREMENT - BEFORE INDEXES
-- =============================================

-- Note: Run these queries BEFORE creating the indexes above
-- to measure baseline performance

-- Query 1: Property search by location and price range
EXPLAIN (ANALYZE, BUFFERS) 
SELECT property_id, name, location, pricepernight
FROM properties 
WHERE location LIKE 'New York%' 
AND pricepernight BETWEEN 100 AND 200;

-- Query 2: Find available properties for date range
EXPLAIN (ANALYZE, BUFFERS)
SELECT p.property_id, p.name, p.location, p.pricepernight
FROM properties p
WHERE p.property_id NOT IN (
    SELECT b.property_id
    FROM bookings b
    WHERE b.status IN ('confirmed', 'pending')
    AND b.start_date <= '2023-04-15'
    AND b.end_date >= '2023-04-10'
);

-- Query 3: Get user booking history with property details
EXPLAIN (ANALYZE, BUFFERS)
SELECT u.first_name, u.last_name, b.start_date, b.end_date, 
       p.name as property_name, p.location
FROM users u
JOIN bookings b ON u.user_id = b.user_id
JOIN properties p ON b.property_id = p.property_id
WHERE u.user_id = 'e5f6g7h8-5678-9012-9004-ef1234567890'
ORDER BY b.created_at DESC;

-- Query 4: Find highly rated properties with recent reviews
EXPLAIN (ANALYZE, BUFFERS)
SELECT p.property_id, p.name, p.location, 
       AVG(r.rating) as avg_rating,
       COUNT(r.review_id) as review_count
FROM properties p
JOIN reviews r ON p.property_id = r.property_id
WHERE r.rating >= 4
AND r.created_at >= '2023-03-01'
GROUP BY p.property_id, p.name, p.location
HAVING COUNT(r.review_id) >= 1
ORDER BY avg_rating DESC, review_count DESC;

-- Query 5: Get message conversations between two users
EXPLAIN (ANALYZE, BUFFERS)
SELECT m.sender_id, m.recipient_id, m.message_body, m.sent_at
FROM messages m
WHERE (m.sender_id = 'e5f6g7h8-5678-9012-9004-ef1234567890' 
       AND m.recipient_id = 'b2c3d4e5-2345-6789-9001-bcdef1234567')
   OR (m.sender_id = 'b2c3d4e5-2345-6789-9001-bcdef1234567' 
       AND m.recipient_id = 'e5f6g7h8-5678-9012-9004-ef1234567890')
ORDER BY m.sent_at DESC;

-- Query 6: Revenue report by host
EXPLAIN (ANALYZE, BUFFERS)
SELECT u.user_id, u.first_name, u.last_name,
       COUNT(b.booking_id) as total_bookings,
       SUM(p.amount) as total_revenue
FROM users u
JOIN properties pr ON u.user_id = pr.host_id
JOIN bookings b ON pr.property_id = b.property_id
JOIN payments p ON b.booking_id = p.booking_id
WHERE u.role = 'host'
AND b.status = 'confirmed'
AND p.payment_date BETWEEN '2023-03-01' AND '2023-04-30'
GROUP BY u.user_id, u.first_name, u.last_name
ORDER BY total_revenue DESC;

-- =============================================
-- 4. PERFORMANCE MEASUREMENT - AFTER INDEXES
-- =============================================

-- Now run the same queries AFTER creating the indexes
-- to measure performance improvement

-- Query 1: Property search by location and price range (with new index)
EXPLAIN (ANALYZE, BUFFERS) 
SELECT property_id, name, location, pricepernight
FROM properties 
WHERE location LIKE 'New York%' 
AND pricepernight BETWEEN 100 AND 200;

-- Query 2: Find available properties for date range (with new indexes)
EXPLAIN (ANALYZE, BUFFERS)
SELECT p.property_id, p.name, p.location, p.pricepernight
FROM properties p
WHERE p.property_id NOT IN (
    SELECT b.property_id
    FROM bookings b
    WHERE b.status IN ('confirmed', 'pending')
    AND b.start_date <= '2023-04-15'
    AND b.end_date >= '2023-04-10'
);

-- Query 3: Get user booking history with property details (with new indexes)
EXPLAIN (ANALYZE, BUFFERS)
SELECT u.first_name, u.last_name, b.start_date, b.end_date, 
       p.name as property_name, p.location
FROM users u
JOIN bookings b ON u.user_id = b.user_id
JOIN properties p ON b.property_id = p.property_id
WHERE u.user_id = 'e5f6g7h8-5678-9012-9004-ef1234567890'
ORDER BY b.created_at DESC;

-- Query 4: Find highly rated properties with recent reviews (with new index)
EXPLAIN (ANALYZE, BUFFERS)
SELECT p.property_id, p.name, p.location, 
       AVG(r.rating) as avg_rating,
       COUNT(r.review_id) as review_count
FROM properties p
JOIN reviews r ON p.property_id = r.property_id
WHERE r.rating >= 4
AND r.created_at >= '2023-03-01'
GROUP BY p.property_id, p.name, p.location
HAVING COUNT(r.review_id) >= 1
ORDER BY avg_rating DESC, review_count DESC;

-- Query 5: Get message conversations between two users (with new index)
EXPLAIN (ANALYZE, BUFFERS)
SELECT m.sender_id, m.recipient_id, m.message_body, m.sent_at
FROM messages m
WHERE (m.sender_id = 'e5f6g7h8-5678-9012-9004-ef1234567890' 
       AND m.recipient_id = 'b2c3d4e5-2345-6789-9001-bcdef1234567')
   OR (m.sender_id = 'b2c3d4e5-2345-6789-9001-bcdef1234567' 
       AND m.recipient_id = 'e5f6g7h8-5678-9012-9004-ef1234567890')
ORDER BY m.sent_at DESC;

-- Query 6: Revenue report by host (with new indexes)
EXPLAIN (ANALYZE, BUFFERS)
SELECT u.user_id, u.first_name, u.last_name,
       COUNT(b.booking_id) as total_bookings,
       SUM(p.amount) as total_revenue
FROM users u
JOIN properties pr ON u.user_id = pr.host_id
JOIN bookings b ON pr.property_id = b.property_id
JOIN payments p ON b.booking_id = p.booking_id
WHERE u.role = 'host'
AND b.status = 'confirmed'
AND p.payment_date BETWEEN '2023-03-01' AND '2023-04-30'
GROUP BY u.user_id, u.first_name, u.last_name
ORDER BY total_revenue DESC;

-- =============================================
-- 5. INDEX USAGE STATISTICS
-- =============================================

-- Check which indexes are being used
SELECT 
    schemaname,
    tablename,
    indexname,
    idx_scan as index_scans,
    idx_tup_read as tuples_read,
    idx_tup_fetch as tuples_fetched
FROM pg_stat_user_indexes
ORDER BY idx_scan DESC;

-- =============================================
-- 6. INDEX MAINTENANCE
-- =============================================

-- Update table statistics for better query planning
ANALYZE properties;
ANALYZE bookings;
ANALYZE users;
ANALYZE reviews;
ANALYZE messages;
ANALYZE payments;

-- =============================================
-- 7. PERFORMANCE COMPARISON QUERIES
-- =============================================

-- Compare query plans for specific operations

-- Example: Show the difference in booking date range queries
EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT COUNT(*) as active_bookings
FROM bookings
WHERE start_date BETWEEN '2023-03-01' AND '2023-04-30'
AND status = 'confirmed';

-- Check index size and usage
SELECT 
    i.relname as index_name,
    t.relname as table_name,
    pg_size_pretty(pg_relation_size(i.oid)) as index_size,
    idx_scan as index_scans,
    idx_tup_read as tuples_read
FROM pg_class t
JOIN pg_index ix ON t.oid = ix.indrelid
JOIN pg_class i ON i.oid = ix.indexrelid
LEFT JOIN pg_stat_user_indexes ui ON i.relname = ui.indexname
WHERE t.relname IN ('properties', 'bookings', 'users', 'reviews', 'messages', 'payments')
ORDER BY pg_relation_size(i.oid) DESC;



-- AirBnB Database Index Performance Measurement Script
-- This script measures query performance before and after adding indexes

-- =============================================
-- 1. PERFORMANCE MEASUREMENT - BEFORE INDEXES
-- =============================================

-- First, let's see what indexes already exist
SELECT 
    tablename, 
    indexname, 
    indexdef 
FROM pg_indexes 
WHERE schemaname = 'public'
ORDER BY tablename, indexname;

-- Record start time for performance measurement
SELECT 'STARTING PERFORMANCE MEASUREMENT - BEFORE INDEXES' as info;

-- Query 1: Property search by location and price range
SELECT 'QUERY 1: Property search by location and price range' as query_name;
EXPLAIN ANALYZE 
SELECT property_id, name, location, pricepernight
FROM properties 
WHERE location LIKE 'New York%' 
AND pricepernight BETWEEN 100 AND 200;

-- Query 2: Find available properties for date range
SELECT 'QUERY 2: Find available properties for date range' as query_name;
EXPLAIN ANALYZE
SELECT p.property_id, p.name, p.location, p.pricepernight
FROM properties p
WHERE p.property_id NOT IN (
    SELECT b.property_id
    FROM bookings b
    WHERE b.status IN ('confirmed', 'pending')
    AND b.start_date <= '2023-04-15'
    AND b.end_date >= '2023-04-10'
);

-- Query 3: Get user booking history with property details
SELECT 'QUERY 3: Get user booking history with property details' as query_name;
EXPLAIN ANALYZE
SELECT u.first_name, u.last_name, b.start_date, b.end_date, 
       p.name as property_name, p.location
FROM users u
JOIN bookings b ON u.user_id = b.user_id
JOIN properties p ON b.property_id = p.property_id
WHERE u.user_id = 'e5f6g7h8-5678-9012-9004-ef1234567890'
ORDER BY b.created_at DESC;

-- Query 4: Find highly rated properties with recent reviews
SELECT 'QUERY 4: Find highly rated properties with recent reviews' as query_name;
EXPLAIN ANALYZE
SELECT p.property_id, p.name, p.location, 
       AVG(r.rating) as avg_rating,
       COUNT(r.review_id) as review_count
FROM properties p
JOIN reviews r ON p.property_id = r.property_id
WHERE r.rating >= 4
AND r.created_at >= '2023-03-01'
GROUP BY p.property_id, p.name, p.location
HAVING COUNT(r.review_id) >= 1
ORDER BY avg_rating DESC, review_count DESC;

-- Query 5: Get message conversations between two users
SELECT 'QUERY 5: Get message conversations between two users' as query_name;
EXPLAIN ANALYZE
SELECT m.sender_id, m.recipient_id, m.message_body, m.sent_at
FROM messages m
WHERE (m.sender_id = 'e5f6g7h8-5678-9012-9004-ef1234567890' 
       AND m.recipient_id = 'b2c3d4e5-2345-6789-9001-bcdef1234567')
   OR (m.sender_id = 'b2c3d4e5-2345-6789-9001-bcdef1234567' 
       AND m.recipient_id = 'e5f6g7h8-5678-9012-9004-ef1234567890')
ORDER BY m.sent_at DESC;

-- Query 6: Revenue report by host
SELECT 'QUERY 6: Revenue report by host' as query_name;
EXPLAIN ANALYZE
SELECT u.user_id, u.first_name, u.last_name,
       COUNT(b.booking_id) as total_bookings,
       SUM(p.amount) as total_revenue
FROM users u
JOIN properties pr ON u.user_id = pr.host_id
JOIN bookings b ON pr.property_id = b.property_id
JOIN payments p ON b.booking_id = p.booking_id
WHERE u.role = 'host'
AND b.status = 'confirmed'
AND p.payment_date BETWEEN '2023-03-01' AND '2023-04-30'
GROUP BY u.user_id, u.first_name, u.last_name
ORDER BY total_revenue DESC;

-- =============================================
-- 2. CREATE ADDITIONAL INDEXES
-- =============================================

SELECT 'CREATING ADDITIONAL INDEXES' as info;

-- Composite index for property search (location + price range)
CREATE INDEX IF NOT EXISTS idx_properties_location_price 
ON properties(location, pricepernight);

-- Index for booking date range queries
CREATE INDEX IF NOT EXISTS idx_bookings_date_range 
ON bookings(start_date, end_date);

-- Composite index for user role-based queries
CREATE INDEX IF NOT EXISTS idx_users_role_email 
ON users(role, email);

-- Index for review ratings and recency
CREATE INDEX IF NOT EXISTS idx_reviews_rating_recency 
ON reviews(rating, created_at);

-- Index for message conversations between users
CREATE INDEX IF NOT EXISTS idx_messages_conversation 
ON messages(sender_id, recipient_id, sent_at);

-- Partial index for active bookings only
CREATE INDEX IF NOT EXISTS idx_bookings_active 
ON bookings(property_id, start_date) 
WHERE status IN ('pending', 'confirmed');

-- Index for payment date ranges
CREATE INDEX IF NOT EXISTS idx_payments_date 
ON payments(payment_date);

-- =============================================
-- 3. PERFORMANCE MEASUREMENT - AFTER INDEXES
-- =============================================

SELECT 'STARTING PERFORMANCE MEASUREMENT - AFTER INDEXES' as info;

-- Query 1: Property search by location and price range (with new index)
SELECT 'QUERY 1: Property search by location and price range (AFTER INDEX)' as query_name;
EXPLAIN ANALYZE 
SELECT property_id, name, location, pricepernight
FROM properties 
WHERE location LIKE 'New York%' 
AND pricepernight BETWEEN 100 AND 200;

-- Query 2: Find available properties for date range (with new indexes)
SELECT 'QUERY 2: Find available properties for date range (AFTER INDEX)' as query_name;
EXPLAIN ANALYZE
SELECT p.property_id, p.name, p.location, p.pricepernight
FROM properties p
WHERE p.property_id NOT IN (
    SELECT b.property_id
    FROM bookings b
    WHERE b.status IN ('confirmed', 'pending')
    AND b.start_date <= '2023-04-15'
    AND b.end_date >= '2023-04-10'
);

-- Query 3: Get user booking history with property details (with new indexes)
SELECT 'QUERY 3: Get user booking history with property details (AFTER INDEX)' as query_name;
EXPLAIN ANALYZE
SELECT u.first_name, u.last_name, b.start_date, b.end_date, 
       p.name as property_name, p.location
FROM users u
JOIN bookings b ON u.user_id = b.user_id
JOIN properties p ON b.property_id = p.property_id
WHERE u.user_id = 'e5f6g7h8-5678-9012-9004-ef1234567890'
ORDER BY b.created_at DESC;

-- Query 4: Find highly rated properties with recent reviews (with new index)
SELECT 'QUERY 4: Find highly rated properties with recent reviews (AFTER INDEX)' as query_name;
EXPLAIN ANALYZE
SELECT p.property_id, p.name, p.location, 
       AVG(r.rating) as avg_rating,
       COUNT(r.review_id) as review_count
FROM properties p
JOIN reviews r ON p.property_id = r.property_id
WHERE r.rating >= 4
AND r.created_at >= '2023-03-01'
GROUP BY p.property_id, p.name, p.location
HAVING COUNT(r.review_id) >= 1
ORDER BY avg_rating DESC, review_count DESC;

-- Query 5: Get message conversations between two users (with new index)
SELECT 'QUERY 5: Get message conversations between two users (AFTER INDEX)' as query_name;
EXPLAIN ANALYZE
SELECT m.sender_id, m.recipient_id, m.message_body, m.sent_at
FROM messages m
WHERE (m.sender_id = 'e5f6g7h8-5678-9012-9004-ef1234567890' 
       AND m.recipient_id = 'b2c3d4e5-2345-6789-9001-bcdef1234567')
   OR (m.sender_id = 'b2c3d4e5-2345-6789-9001-bcdef1234567' 
       AND m.recipient_id = 'e5f6g7h8-5678-9012-9004-ef1234567890')
ORDER BY m.sent_at DESC;

-- Query 6: Revenue report by host (with new indexes)
SELECT 'QUERY 6: Revenue report by host (AFTER INDEX)' as query_name;
EXPLAIN ANALYZE
SELECT u.user_id, u.first_name, u.last_name,
       COUNT(b.booking_id) as total_bookings,
       SUM(p.amount) as total_revenue
FROM users u
JOIN properties pr ON u.user_id = pr.host_id
JOIN bookings b ON pr.property_id = b.property_id
JOIN payments p ON b.booking_id = p.booking_id
WHERE u.role = 'host'
AND b.status = 'confirmed'
AND p.payment_date BETWEEN '2023-03-01' AND '2023-04-30'
GROUP BY u.user_id, u.first_name, u.last_name
ORDER BY total_revenue DESC;

-- =============================================
-- 4. INDEX USAGE AND PERFORMANCE ANALYSIS
-- =============================================

SELECT 'ANALYZING INDEX USAGE AND PERFORMANCE' as info;

-- Check which indexes are being used
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

-- Check index sizes
SELECT 
    i.relname as index_name,
    t.relname as table_name,
    pg_size_pretty(pg_relation_size(i.oid)) as index_size,
    idx_scan as index_scans
FROM pg_class t
JOIN pg_index ix ON t.oid = ix.indrelid
JOIN pg_class i ON i.oid = ix.indexrelid
LEFT JOIN pg_stat_user_indexes ui ON i.relname = ui.indexname
WHERE t.relname IN ('properties', 'bookings', 'users', 'reviews', 'messages', 'payments')
ORDER BY pg_relation_size(i.oid) DESC;

-- Update table statistics
ANALYZE properties;
ANALYZE bookings;
ANALYZE users;
ANALYZE reviews;
ANALYZE messages;
ANALYZE payments;

-- =============================================
-- 5. PERFORMANCE SUMMARY QUERIES
-- =============================================

SELECT 'PERFORMANCE SUMMARY' as info;

-- Show query performance improvements
SELECT 'Compare execution times from EXPLAIN ANALYZE output above:' as note;
SELECT 'Look for reductions in:' as improvement_areas;
SELECT '- Execution time' as area;
SELECT '- Planning time' as area;
SELECT '- Number of rows scanned' as area;
SELECT '- Buffer usage' as area;

-- Final index usage report
SELECT 
    tablename,
    indexname,
    pg_size_pretty(pg_relation_size(indexname::regclass)) as size,
    idx_scan as scans
FROM pg_indexes 
JOIN pg_stat_user_indexes USING (indexname)
WHERE schemaname = 'public'
ORDER BY tablename, indexname;
