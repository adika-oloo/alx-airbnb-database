-- 1. INNER JOIN: Get all bookings with the users who made them
SELECT
    b.booking_id,
    b.property_id,
    b.check_in,
    b.check_out,
    u.user_id,
    u.name AS user_name,
    u.email AS user_email
FROM bookings AS b
INNER JOIN users AS u
    ON b.user_id = u.user_id;


-- 2. LEFT JOIN: Get all properties with their reviews (including properties without reviews)
SELECT
    p.property_id,
    p.name AS property_name,
    r.review_id,
    r.rating,
    r.comment
FROM properties AS p
LEFT JOIN reviews AS r
    ON p.property_id = r.property_id;


-- 3. FULL OUTER JOIN: Get all users and all bookings
-- (works in PostgreSQL; MySQL doesn’t support FULL OUTER JOIN directly)
SELECT
    u.user_id,
    u.name AS user_name,
    b.booking_id,
    b.property_id,
    b.check_in,
    b.check_out
FROM users AS u
FULL OUTER JOIN bookings AS b
    ON u.user_id = b.user_id;
