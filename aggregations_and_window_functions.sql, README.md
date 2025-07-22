Total number of bookings made by each user (Aggregation with COUNT and 
SELECT 
    u.id AS user_id,
    u.name,
    COUNT(b.id) AS total_bookings
FROM 
    users u
LEFT JOIN 
    bookings b ON u.id = b.user_id
GROUP BY 
    u.id, u.name
ORDER BY 
    total_bookings DESC;
Explanation:

    This query uses COUNT() to get the total bookings per user.

    LEFT JOIN ensures users with zero bookings are still listed.

    Results are sorted from most to least bookings.

    Rank properties based on the number of bookings (Window function): 
    SELECT 
    p.id AS property_id,
    p.name,
    COUNT(b.id) AS total_bookings,
    RANK() OVER (ORDER BY COUNT(b.id) DESC) AS booking_rank
FROM 
    properties p
LEFT JOIN 
    bookings b ON p.id = b.property_id
GROUP BY 
    p.id, p.name
ORDER BY 
    booking_rank;
Explanation:

    COUNT(b.id) gives total bookings per property.

    RANK() assigns a rank to each property based on the booking count.

    Ties (same booking count) get the same rank, and gaps follow.
