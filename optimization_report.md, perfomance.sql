Initial Query (Unoptimized)
##Create a file named performance.sql and start with this unoptimized query:
-- Initial unoptimized query: Retrieve all bookings with user, property, and payment details
SELECT 
    b.id AS booking_id,
    b.booking_date,
    b.check_in,
    b.check_out,
    u.id AS user_id,
    u.name AS user_name,
    p.id AS property_id,
    p.name AS property_name,
    pay.id AS payment_id,
    pay.amount,
    pay.payment_date
FROM 
    bookings b
JOIN 
    users u ON b.user_id = u.id
JOIN 
    properties p ON b.property_id = p.id
LEFT JOIN 
    payments pay ON b.id = pay.booking_id;

Analyze Performance Using EXPLAIN
##to analyze performance:
EXPLAIN ANALYZE
SELECT 
    b.id AS booking_id,
    b.booking_date,
    b.check_in,
    b.check_out,
    u.id AS user_id,
    u.name AS user_name,
    p.id AS property_id,
    p.name AS property_name,
    pay.id AS payment_id,
    pay.amount,
    pay.payment_date
FROM 
    bookings b
JOIN 
    users u ON b.user_id = u.id
JOIN 
    properties p ON b.property_id = p.id
LEFT JOIN 
    payments pay ON b.id = pay.booking_id;

Refactor for Performance
Refactor 1: Add selective fields only (avoid SELECT *)
Refactor 2: Ensure indexes exist on user_id, property_id, booking_id
Refactor 3: Consider denormalization if used frequently
-- Refactored query with improved performance
SELECT 
    b.id AS booking_id,
    b.booking_date,
    b.check_in,
    b.check_out,
    u.name AS user_name,
    p.name AS property_name,
    pay.amount,
    pay.payment_date
FROM 
    bookings b
JOIN 
    users u ON b.user_id = u.id
JOIN 
    properties p ON b.property_id = p.id
LEFT JOIN 
    payments pay ON pay.booking_id = b.id;

Compare with EXPLAIN Again
Run EXPLAIN ANALYZE on the refactored query to compare the execution time and query plan.
  -- Initial query
SELECT ...
FROM ...
JOIN ...
-- Add EXPLAIN ANALYZE here if needed

-- Refactored query
SELECT ...
FROM ...
JOIN ...
-- Add EXPLAIN ANALYZE for comparison

