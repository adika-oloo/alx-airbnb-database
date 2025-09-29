-- Query 1: Total number of bookings made by each user
SELECT u.id AS user_id, u.name AS user_name, COUNT(b.id) AS total_bookings
FROM users u
LEFT JOIN bookings b ON u.id = b.user_id
GROUP BY u.id, u.name
ORDER BY total_bookings DESC;

-- Query 2a: Rank properties using ROW_NUMBER based on total number of bookings
SELECT p.id AS property_id, p.name AS property_name, 
       COUNT(b.id) AS total_bookings,
       ROW_NUMBER() OVER (ORDER BY COUNT(b.id) DESC) AS booking_row_number
FROM properties p
LEFT JOIN bookings b ON p.id = b.property_id
GROUP BY p.id, p.name
ORDER BY booking_row_number;

-- Query 2b: Rank properties using RANK based on total number of bookings
SELECT p.id AS property_id, p.name AS property_name, 
       COUNT(b.id) AS total_bookings,
       RANK() OVER (ORDER BY COUNT(b.id) DESC) AS booking_rank
FROM properties p
LEFT JOIN bookings b ON p.id = b.property_id
GROUP BY p.id, p.name
ORDER BY booking_rank;
