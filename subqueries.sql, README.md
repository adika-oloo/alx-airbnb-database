Non-Correlated Subquery – Properties with avg rating > 4.0
SELECT 
    p.id,
    p.name,
    p.location
FROM 
    properties p
WHERE 
    p.id IN (
        SELECT 
            property_id
        FROM 
            reviews
        GROUP BY 
            property_id
        HAVING 
            AVG(rating) > 4.0
    );
Explanation:

    The subquery calculates the average rating per property_id.

    The outer query retrieves property details only for those with an average rating greater than 4.0.

   This is a non-correlated subquery because it runs independently of the outer query.

   Correlated Subquery – Users with more than 3 bookings
   SELECT 
    u.id,
    u.name,
    u.email
FROM 
    users u
WHERE 
    (
        SELECT 
            COUNT(*) 
        FROM 
            bookings b
        WHERE 
            b.user_id = u.id
    ) > 3;
Explanation:

    The subquery counts the number of bookings per user by referencing the outer query's u.id.

    Only users with more than 3 bookings are returned.

     This is a correlated subquery because it runs once for each row in the outer query, using a reference from it.
