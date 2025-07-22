INNER JOIN – All bookings and respective users
SELECT 
    bookings.id AS booking_id,
    bookings.property_id,
    bookings.start_date,
    bookings.end_date,
    users.id AS user_id,
    users.name,
    users.email
FROM 
    bookings
INNER JOIN 
    users ON bookings.user_id = users.id;
##INNER JOIN returns only the rows where a matching user_id exists in both bookings and users.

 LEFT JOIN – All properties and their reviews (include those with no reviews)
 SELECT 
    properties.id AS property_id,
    properties.name AS property_name,
    reviews.id AS review_id,
    reviews.rating,
    reviews.comment
FROM 
    properties
LEFT JOIN 
    reviews ON properties.id = reviews.property_id;
##LEFT JOIN returns all properties, and their reviews if they exist. If a property has no review, review_id, rating, and comment will be NULL.

FULL OUTER JOIN – All users and all bookings, even if not matched
SELECT 
    users.id AS user_id,
    users.name,
    bookings.id AS booking_id,
    bookings.property_id,
    bookings.start_date,
    bookings.end_date
FROM 
    users
FULL OUTER JOIN 
    bookings ON users.id = bookings.user_id;
##FULL OUTER JOIN returns:
    Users with and without bookings
    Bookings with and without users (e.g., orphan records)
