-- AirBnB Sample Data Population Script
-- This script populates all tables with realistic sample data

-- Start a transaction to ensure data integrity
BEGIN;

-- =============================================
-- 1. USERS DATA
-- =============================================

INSERT INTO users (user_id, first_name, last_name, email, password_hash, phone_number, role, created_at) VALUES
-- Admin user
('a1b2c3d4-1234-5678-9000-abcdef123456', 'Admin', 'User', 'admin@airbnb.com', '$2b$10$exampleHash1234567890', '+1234567890', 'admin', '2023-01-01 10:00:00'),

-- Hosts
('b2c3d4e5-2345-6789-9001-bcdef1234567', 'Sarah', 'Johnson', 'sarah.johnson@email.com', '$2b$10$exampleHash2345678901', '+1234567891', 'host', '2023-01-15 14:30:00'),
('c3d4e5f6-3456-7890-9002-cdef12345678', 'Mike', 'Chen', 'mike.chen@email.com', '$2b$10$exampleHash3456789012', '+1234567892', 'host', '2023-02-10 09:15:00'),
('d4e5f6g7-4567-8901-9003-def123456789', 'Emma', 'Rodriguez', 'emma.rodriguez@email.com', '$2b$10$exampleHash4567890123', '+1234567893', 'host', '2023-02-20 16:45:00'),

-- Guests
('e5f6g7h8-5678-9012-9004-ef1234567890', 'John', 'Smith', 'john.smith@email.com', '$2b$10$exampleHash5678901234', '+1234567894', 'guest', '2023-01-20 11:20:00'),
('f6g7h8i9-6789-0123-9005-f12345678901', 'Lisa', 'Wang', 'lisa.wang@email.com', '$2b$10$exampleHash6789012345', '+1234567895', 'guest', '2023-02-05 13:10:00'),
('g7h8i9j0-7890-1234-9006-123456789012', 'David', 'Brown', 'david.brown@email.com', '$2b$10$exampleHash7890123456', '+1234567896', 'guest', '2023-02-25 08:30:00'),
('h8i9j0k1-8901-2345-9007-234567890123', 'Maria', 'Garcia', 'maria.garcia@email.com', '$2b$10$exampleHash8901234567', '+1234567897', 'guest', '2023-03-10 15:40:00');

-- =============================================
-- 2. PROPERTIES DATA
-- =============================================

INSERT INTO properties (property_id, host_id, name, description, location, pricepernight, created_at, updated_at) VALUES
-- Sarah Johnson's properties
('p1a2b3c4-1234-5678-9000-property0001', 'b2c3d4e5-2345-6789-9001-bcdef1234567', 'Cozy Downtown Apartment', 'Beautiful modern apartment in the heart of downtown. Perfect for couples or solo travelers. Features a fully equipped kitchen, high-speed WiFi, and stunning city views.', 'New York, NY', 120.00, '2023-01-20 10:00:00', '2023-01-20 10:00:00'),
('p2b3c4d5-2345-6789-9001-property0002', 'b2c3d4e5-2345-6789-9001-bcdef1234567', 'Lakeside Cabin Retreat', 'Peaceful cabin by the lake with private beach access. Perfect for nature lovers. Includes fireplace, kayaks, and outdoor BBQ area.', 'Lake Tahoe, CA', 95.00, '2023-02-01 14:20:00', '2023-02-01 14:20:00'),

-- Mike Chen's properties
('p3c4d5e6-3456-7890-9002-property0003', 'c3d4e5f6-3456-7890-9002-cdef12345678', 'Modern City Loft', 'Spacious industrial-style loft with exposed brick walls. Located in trendy neighborhood with great restaurants and shops nearby.', 'San Francisco, CA', 150.00, '2023-02-15 09:30:00', '2023-02-15 09:30:00'),
('p4d5e6f7-4567-8901-9003-property0004', 'c3d4e5f6-3456-7890-9002-cdef12345678', 'Beachfront Villa', 'Luxury beachfront property with private pool and direct beach access. Perfect for families or groups. Includes daily cleaning service.', 'Miami, FL', 250.00, '2023-02-25 16:10:00', '2023-03-01 11:20:00'),

-- Emma Rodriguez's properties
('p5e6f7g8-5678-9012-9004-property0005', 'd4e5f6g7-4567-8901-9003-def123456789', 'Mountain View Chalet', 'Charming chalet with panoramic mountain views. Features hot tub, fireplace, and hiking trail access. Pet-friendly.', 'Aspen, CO', 180.00, '2023-03-05 12:45:00', '2023-03-05 12:45:00');

-- =============================================
-- 3. BOOKINGS DATA
-- =============================================

INSERT INTO bookings (booking_id, property_id, user_id, start_date, end_date, total_price, status, created_at) VALUES
-- John Smith's bookings
('b1c2d3e4-1234-5678-9000-booking00001', 'p1a2b3c4-1234-5678-9000-property0001', 'e5f6g7h8-5678-9012-9004-ef1234567890', '2023-03-15', '2023-03-20', 600.00, 'confirmed', '2023-03-01 08:15:00'),
('b2c3d4e5-2345-6789-9001-booking00002', 'p3c4d5e6-3456-7890-9002-property0003', 'e5f6g7h8-5678-9012-9004-ef1234567890', '2023-04-10', '2023-04-15', 750.00, 'confirmed', '2023-03-20 14:30:00'),

-- Lisa Wang's bookings
('b3d4e5f6-3456-7890-9002-booking00003', 'p2b3c4d5-2345-6789-9001-property0002', 'f6g7h8i9-6789-0123-9005-f12345678901', '2023-03-25', '2023-03-30', 475.00, 'confirmed', '2023-03-10 10:45:00'),
('b4e5f6g7-4567-8901-9003-booking00004', 'p5e6f7g8-5678-9012-9004-property0005', 'f6g7h8i9-6789-0123-9005-f12345678901', '2023-05-01', '2023-05-07', 1080.00, 'pending', '2023-04-15 16:20:00'),

-- David Brown's bookings
('b5f6g7h8-5678-9012-9004-booking00005', 'p4d5e6f7-4567-8901-9003-property0004', 'g7h8i9j0-7890-1234-9006-123456789012', '2023-04-05', '2023-04-12', 1750.00, 'confirmed', '2023-03-25 11:10:00'),

-- Maria Garcia's booking (canceled)
('b6g7h8i9-6789-0123-9005-booking00006', 'p1a2b3c4-1234-5678-9000-property0001', 'h8i9j0k1-8901-2345-9007-234567890123', '2023-04-18', '2023-04-22', 480.00, 'canceled', '2023-04-01 09:30:00');

-- =============================================
-- 4. PAYMENTS DATA
-- =============================================

INSERT INTO payments (payment_id, booking_id, amount, payment_date, payment_method) VALUES
-- Payments for John Smith's bookings
('pay1a2b3c4-1234-5678-9000-payment0001', 'b1c2d3e4-1234-5678-9000-booking00001', 600.00, '2023-03-01 08:20:00', 'credit_card'),
('pay2b3c4d5-2345-6789-9001-payment0002', 'b2c3d4e5-2345-6789-9001-booking00002', 750.00, '2023-03-20 14:35:00', 'stripe'),

-- Payments for Lisa Wang's bookings
('pay3c4d5e6-3456-7890-9002-payment0003', 'b3d4e5f6-3456-7890-9002-booking00003', 475.00, '2023-03-10 10:50:00', 'paypal'),

-- Payments for David Brown's bookings
('pay4d5e6f7-4567-8901-9003-payment0004', 'b5f6g7h8-5678-9012-9004-booking00005', 1750.00, '2023-03-25 11:15:00', 'credit_card'),

-- Refund for canceled booking
('pay5e6f7g8-5678-9012-9004-payment0005', 'b6g7h8i9-6789-0123-9005-booking00006', -480.00, '2023-04-02 10:00:00', 'credit_card');

-- =============================================
-- 5. REVIEWS DATA
-- =============================================

INSERT INTO reviews (review_id, property_id, user_id, rating, comment, created_at) VALUES
-- Reviews for Cozy Downtown Apartment
('rev1a2b3c4-1234-5678-9000-review0001', 'p1a2b3c4-1234-5678-9000-property0001', 'e5f6g7h8-5678-9012-9004-ef1234567890', 5, 'Absolutely loved our stay! The apartment was even better than the photos. Perfect location and Sarah was a wonderful host. Would definitely book again!', '2023-03-21 14:00:00'),

-- Reviews for Lakeside Cabin
('rev2b3c4d5-2345-6789-9001-review0002', 'p2b3c4d5-2345-6789-9001-property0002', 'f6g7h8i9-6789-0123-9005-f12345678901', 4, 'Beautiful location and very peaceful. The cabin had everything we needed. The only minor issue was the WiFi was a bit slow, but we came to disconnect anyway!', '2023-03-31 16:30:00'),

-- Reviews for Modern City Loft
('rev3c4d5e6-3456-7890-9002-review0003', 'p3c4d5e6-3456-7890-9002-property0003', 'e5f6g7h8-5678-9012-9004-ef1234567890', 5, 'This loft is incredible! The design is stunning and the location can''t be beat. Mike was very responsive and helpful throughout our stay.', '2023-04-16 10:15:00'),

-- Reviews for Beachfront Villa
('rev4d5e6f7-4567-8901-9003-review0004', 'p4d5e6f7-4567-8901-9003-property0004', 'g7h8i9j0-7890-1234-9006-123456789012', 5, 'Pure luxury! The villa exceeded all expectations. Waking up to ocean views every morning was magical. Worth every penny!', '2023-04-13 09:45:00'),

-- Review for Mountain View Chalet
('rev5e6f7g8-5678-9012-9004-review0005', 'p5e6f7g8-5678-9012-9004-property0005', 'f6g7h8i9-6789-0123-9005-f12345678901', 4, 'Great chalet with amazing views! Very cozy and well-equipped. The hot tub was perfect after a day of hiking. Emma was a fantastic host!', '2023-03-28 18:20:00');

-- =============================================
-- 6. MESSAGES DATA
-- =============================================

INSERT INTO messages (message_id, sender_id, recipient_id, message_body, sent_at) VALUES
-- Conversation between John Smith and Sarah Johnson
('msg1a2b3c4-1234-5678-9000-message0001', 'e5f6g7h8-5678-9012-9004-ef1234567890', 'b2c3d4e5-2345-6789-9001-bcdef1234567', 'Hi Sarah, I''m interested in your downtown apartment for March 15-20. Is it available?', '2023-02-28 15:30:00'),
('msg2b3c4d5-2345-6789-9001-message0002', 'b2c3d4e5-2345-6789-9001-bcdef1234567', 'e5f6g7h8-5678-9012-9004-ef1234567890', 'Hi John! Yes, those dates are available. The apartment would be perfect for your stay. Let me know if you have any questions!', '2023-02-28 16:45:00'),

-- Conversation between Lisa Wang and Mike Chen
('msg3c4d5e6-3456-7890-9002-message0003', 'f6g7h8i9-6789-0123-9005-f12345678901', 'c3d4e5f6-3456-7890-9002-cdef12345678', 'Hello Mike, I saw your beachfront villa and it looks amazing! Do you allow pets?', '2023-03-24 11:20:00'),
('msg4d5e6f7-4567-8901-9003-message0004', 'c3d4e5f6-3456-7890-9002-cdef12345678', 'f6g7h8i9-6789-0123-9005-f12345678901', 'Hi Lisa! Unfortunately, we don''t allow pets at the beachfront villa due to allergy concerns for future guests. Our mountain chalet is pet-friendly though!', '2023-03-24 12:30:00'),

-- Conversation between David Brown and Emma Rodriguez
('msg5e6f7g8-5678-9012-9004-message0005', 'g7h8i9j0-7890-1234-9006-123456789012', 'd4e5f6g7-4567-8901-9003-def123456789', 'Hi Emma, is there parking available at the chalet? We''re planning to drive up.', '2023-04-04 09:15:00'),
('msg6f7g8h9-6789-0123-9005-message0006', 'd4e5f6g7-4567-8901-9003-def123456789', 'g7h8i9j0-7890-1234-9006-123456789012', 'Hi David! Yes, there is dedicated parking for 2 vehicles right next to the chalet. No additional fees!', '2023-04-04 10:05:00'),

-- Conversation about canceled booking
('msg7g8h9i0-7890-1234-9006-message0007', 'h8i9j0k1-8901-2345-9007-234567890123', 'b2c3d4e5-2345-6789-9001-bcdef1234567', 'Hi Sarah, unfortunately I need to cancel my booking for April 18-22 due to a family emergency.', '2023-04-01 08:45:00'),
('msg8h9i0j1-8901-2345-9007-message0008', 'b2c3d4e5-2345-6789-9001-bcdef1234567', 'h8i9j0k1-8901-2345-9007-234567890123', 'I''m sorry to hear that, Maria. I''ve processed your cancellation and full refund. Hope everything is okay with your family.', '2023-04-01 09:15:00');

-- =============================================
-- COMMIT TRANSACTION
-- =============================================

COMMIT;

-- =============================================
-- VERIFICATION QUERIES (Optional)
-- =============================================

-- Uncomment below to verify data population
/*
-- Count records in each table
SELECT 'Users' as table_name, COUNT(*) as record_count FROM users
UNION ALL SELECT 'Properties', COUNT(*) FROM properties
UNION ALL SELECT 'Bookings', COUNT(*) FROM bookings
UNION ALL SELECT 'Payments', COUNT(*) FROM payments
UNION ALL SELECT 'Reviews', COUNT(*) FROM reviews
UNION ALL SELECT 'Messages', COUNT(*) FROM messages;

-- Show some sample data
SELECT u.first_name, u.last_name, u.role, p.name as property_name, b.start_date, b.end_date, b.status 
FROM users u
LEFT JOIN properties p ON u.user_id = p.host_id
LEFT JOIN bookings b ON u.user_id = b.user_id
WHERE u.role IN ('host', 'guest')
ORDER BY u.role, u.last_name;
*/
