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
