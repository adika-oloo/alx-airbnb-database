-- perfomance.sql
-- AirBnB Database Performance Analysis
-- Initial query and EXPLAIN ANALYZE for optimization

-- 1. Initial complex query retrieving all bookings with details
SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status AS booking_status,
    b.created_at AS booking_created,
    
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    u.phone_number,
    u.role AS user_role,
    
    p.property_id,
    p.name AS property_name,
    p.description,
    p.location,
    p.pricepernight,
    p.host_id,
    
    pay.payment_id,
    pay.amount AS payment_amount,
    pay.payment_method,
    pay.payment_date

FROM bookings b

INNER JOIN users u 
    ON b.user_id = u.user_id

INNER JOIN properties p 
    ON b.property_id = p.property_id

LEFT JOIN payments pay 
    ON b.booking_id = pay.booking_id

ORDER BY b.created_at DESC;

-- 2. Performance analysis using EXPLAIN ANALYZE
EXPLAIN ANALYZE
SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status AS booking_status,
    
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    
    p.property_id,
    p.name AS property_name,
    p.location,
    p.pricepernight,
    
    pay.payment_id,
    pay.amount AS payment_amount,
    pay.payment_method,
    pay.payment_date

FROM bookings b

INNER JOIN users u 
    ON b.user_id = u.user_id

INNER JOIN properties p 
    ON b.property_id = p.property_id

LEFT JOIN payments pay 
    ON b.booking_id = pay.booking_id

ORDER BY b.created_at DESC;

-- 3. Check if existing indexes are being used
-- This helps identify if we need additional indexes
EXPLAIN ANALYZE
SELECT b.booking_id, u.first_name, u.last_name, p.name
FROM bookings b
JOIN users u ON b.user_id = u.user_id
JOIN properties p ON b.property_id = p.property_id
WHERE b.start_date > '2023-06-01'
LIMIT 100



-- perfomance.sql
-- AirBnB Database Performance Analysis and Optimization
-- This file contains initial queries and EXPLAIN ANALYZE performance analysis

-- =============================================
-- 1. INITIAL COMPLEX QUERY
-- =============================================

-- Query that retrieves all bookings with user, property, and payment details
SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status AS booking_status,
    b.created_at AS booking_created,
    
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    u.phone_number,
    u.role AS user_role,
    
    p.property_id,
    p.name AS property_name,
    p.description,
    p.location,
    p.pricepernight,
    p.host_id,
    
    pay.payment_id,
    pay.amount AS payment_amount,
    pay.payment_method,
    pay.payment_date

FROM bookings b

INNER JOIN users u 
    ON b.user_id = u.user_id

INNER JOIN properties p 
    ON b.property_id = p.property_id

LEFT JOIN payments pay 
    ON b.booking_id = pay.booking_id

WHERE b.status = 'confirmed'
    AND b.start_date >= '2023-03-01'
    AND b.end_date <= '2023-12-31'
    AND p.pricepernight BETWEEN 50 AND 500

ORDER BY b.created_at DESC;

-- =============================================
-- 2. PERFORMANCE ANALYSIS WITH EXPLAIN ANALYZE
-- =============================================

-- Analyze the main query performance
EXPLAIN ANALYZE
SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status AS booking_status,
    
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    
    p.property_id,
    p.name AS property_name,
    p.location,
    p.pricepernight,
    
    pay.payment_id,
    pay.amount AS payment_amount,
    pay.payment_method,
    pay.payment_date

FROM bookings b

INNER JOIN users u 
    ON b.user_id = u.user_id

INNER JOIN properties p 
    ON b.property_id = p.property_id

LEFT JOIN payments pay 
    ON b.booking_id = pay.booking_id

WHERE b.status = 'confirmed'
    AND b.start_date >= '2023-03-01'
    AND b.end_date <= '2023-12-31'
    AND p.pricepernight BETWEEN 50 AND 500

ORDER BY b.created_at DESC;

-- =============================================
-- 3. ADDITIONAL TEST QUERIES WITH COMPLEX CONDITIONS
-- =============================================

-- Query 2: Find properties in specific locations with price range and availability
EXPLAIN ANALYZE
SELECT 
    p.property_id,
    p.name,
    p.location,
    p.pricepernight,
    p.description,
    u.first_name AS host_first_name,
    u.last_name AS host_last_name,
    COUNT(r.review_id) AS review_count,
    AVG(r.rating) AS average_rating
    
FROM properties p

INNER JOIN users u 
    ON p.host_id = u.user_id

LEFT JOIN reviews r 
    ON p.property_id = r.property_id

WHERE p.location LIKE '%New York%' 
    AND p.pricepernight BETWEEN 100 AND 300
    AND u.role = 'host'
    AND p.property_id NOT IN (
        SELECT b.property_id 
        FROM bookings b 
        WHERE b.status IN ('confirmed', 'pending')
        AND b.start_date <= '2023-06-15'
        AND b.end_date >= '2023-06-10'
    )

GROUP BY p.property_id, p.name, p.location, p.pricepernight, p.description, 
         u.first_name, u.last_name

HAVING AVG(r.rating) >= 4.0 
    OR COUNT(r.review_id) = 0

ORDER BY p.pricepernight ASC, average_rating DESC;

-- Query 3: User booking history with filters
EXPLAIN ANALYZE
SELECT 
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    b.booking_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status,
    p.name AS property_name,
    p.location,
    pay.payment_method,
    pay.amount,
    r.rating AS user_rating,
    r.comment AS user_review
    
FROM users u

INNER JOIN bookings b 
    ON u.user_id = b.user_id

INNER JOIN properties p 
    ON b.property_id = p.property_id

LEFT JOIN payments pay 
    ON b.booking_id = pay.booking_id

LEFT JOIN reviews r 
    ON b.property_id = r.property_id 
    AND b.user_id = r.user_id

WHERE u.role = 'guest'
    AND b.created_at >= '2023-01-01'
    AND (b.status = 'confirmed' OR b.status = 'completed')
    AND b.total_price > 0

ORDER BY b.start_date DESC, b.total_price DESC;

-- =============================================
-- 4. CHECK EXISTING INDEXES AND PERFORMANCE
-- =============================================

-- Check current indexes (run this separately)
SELECT 
    tablename, 
    indexname, 
    indexdef 
FROM pg_indexes 
WHERE schemaname = 'public'
    AND tablename IN ('bookings', 'users', 'properties', 'payments', 'reviews')
ORDER BY tablename, indexname;

-- =============================================
-- 5. IDENTIFY POTENTIAL INEFFICIENCIES
-- =============================================

-- Common inefficiencies to look for in EXPLAIN ANALYZE output:
-- 1. Sequential scans (Seq Scan) on large tables
-- 2. High cost for sort operations
-- 3. Nested loops with large row sets
-- 4. Hash joins that could be optimized with indexes
-- 5. Filter conditions that don't use indexes

-- =============================================
-- 6. SUGGESTED INDEXES FOR OPTIMIZATION
-- =============================================

-- These indexes should help optimize the queries above:
/*
-- For booking queries
CREATE INDEX IF NOT EXISTS idx_bookings_status_dates ON bookings(status, start_date, end_date);
CREATE INDEX IF NOT EXISTS idx_bookings_user_status ON bookings(user_id, status);
CREATE INDEX IF NOT EXISTS idx_bookings_dates_price ON bookings(start_date, end_date, total_price);

-- For property queries  
CREATE INDEX IF NOT EXISTS idx_properties_location_price ON properties(location, pricepernight);
CREATE INDEX IF NOT EXISTS idx_properties_host_id ON properties(host_id);

-- For user queries
CREATE INDEX IF NOT EXISTS idx_users_role_email ON users(role, email);

-- For review queries
CREATE INDEX IF NOT EXISTS idx_reviews_property_rating ON reviews(property_id, rating);

-- For payment queries
CREATE INDEX IF NOT EXISTS idx_payments_booking_date ON payments(booking_id, payment_date);
*/

-- =============================================
-- 7. REFACTORED QUERY EXAMPLE
-- =============================================

-- After analyzing performance, here's a refactored version of the main query:
EXPLAIN ANALYZE
SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status AS booking_status,
    
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    
    p.property_id,
    p.name AS property_name,
    p.location,
    p.pricepernight,
    
    pay.payment_id,
    pay.amount AS payment_amount,
    pay.payment_method

FROM bookings b

-- Use EXISTS instead of LEFT JOIN for payments to reduce rows early
INNER JOIN users u ON b.user_id = u.user_id
INNER JOIN properties p ON b.property_id = p.property_id
LEFT JOIN LATERAL (
    SELECT payment_id, amount, payment_method 
    FROM payments 
    WHERE booking_id = b.booking_id 
    ORDER BY payment_date DESC 
    LIMIT 1
) pay ON true

WHERE b.status = 'confirmed'
    AND b.start_date >= '2023-03-01' 
    AND b.start_date <= '2023-12-31'
    AND p.pricepernight >= 50
    AND p.pricepernight <= 500

ORDER BY b.created_at DESC
LIMIT 100; -- Added limit for practical use
