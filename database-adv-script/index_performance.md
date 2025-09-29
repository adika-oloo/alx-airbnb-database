-- Database Index Optimization for ALX Airbnb Database
-- This file contains CREATE INDEX commands to improve query performance

-- =============================================================================
-- USER TABLE INDEXES
-- =============================================================================

-- Drop existing indexes if they exist
DROP INDEX IF EXISTS idx_user_email ON User;
DROP INDEX IF EXISTS idx_user_created_at ON User;
DROP INDEX IF EXISTS idx_user_status ON User;
DROP INDEX IF EXISTS idx_user_location ON User;
DROP INDEX IF EXISTS idx_user_phone ON User;

-- 1. Index on email (for login and user lookup)
CREATE UNIQUE INDEX idx_user_email ON User(email);

-- 2. Index on created_at (for analytics and recent users)
CREATE INDEX idx_user_created_at ON User(created_at);

-- 3. Index on status (for filtering active/inactive users)
CREATE INDEX idx_user_status ON User(status);

-- 4. Index on location (for location-based searches)
CREATE INDEX idx_user_location ON User(location);

-- 5. Index on phone_number (for quick phone lookups)
CREATE INDEX idx_user_phone ON User(phone_number);

-- 6. Composite index for user search functionality
CREATE INDEX idx_user_search ON User(first_name, last_name, email);

-- =============================================================================
-- PROPERTY TABLE INDEXES
-- =============================================================================

-- Drop existing indexes
DROP INDEX IF EXISTS idx_property_host_id ON Property;
DROP INDEX IF EXISTS idx_property_location ON Property;
DROP INDEX IF EXISTS idx_property_price ON Property;
DROP INDEX IF EXISTS idx_property_status ON Property;
DROP INDEX IF EXISTS idx_property_type ON Property;
DROP INDEX IF EXISTS idx_property_created_at ON Property;
DROP INDEX IF EXISTS idx_property_location_price ON Property;

-- 1. Index on host_id (for finding properties by host)
CREATE INDEX idx_property_host_id ON Property(host_id);

-- 2. Index on location (for location-based searches)
CREATE INDEX idx_property_location ON Property(location);

-- 3. Index on price (for price range queries)
CREATE INDEX idx_property_price ON Property(price);

-- 4. Index on status (for filtering available properties)
CREATE INDEX idx_property_status ON Property(status);

-- 5. Index on property_type (for filtering by type)
CREATE INDEX idx_property_type ON Property(property_type);

-- 6. Index on created_at (for new listings)
CREATE INDEX idx_property_created_at ON Property(created_at);

-- 7. Composite index for location and price (common search pattern)
CREATE INDEX idx_property_location_price ON Property(location, price);

-- 8. Composite index for advanced search
CREATE INDEX idx_property_advanced_search ON Property(location, property_type, price, status);

-- =============================================================================
-- BOOKING TABLE INDEXES
-- =============================================================================

-- Drop existing indexes
DROP INDEX IF EXISTS idx_booking_user_id ON Booking;
DROP INDEX IF EXISTS idx_booking_property_id ON Booking;
DROP INDEX IF EXISTS idx_booking_status ON Booking;
DROP INDEX IF EXISTS idx_booking_dates ON Booking;
DROP INDEX IF EXISTS idx_booking_created_at ON Booking;
DROP INDEX IF EXISTS idx_booking_user_status ON Booking;
DROP INDEX IF EXISTS idx_booking_property_dates ON Booking;

-- 1. Index on user_id (for finding user's bookings)
CREATE INDEX idx_booking_user_id ON Booking(user_id);

-- 2. Index on property_id (for finding property's bookings)
CREATE INDEX idx_booking_property_id ON Booking(property_id);

-- 3. Index on status (for filtering by booking status)
CREATE INDEX idx_booking_status ON Booking(status);

-- 4. Composite index on check_in and check_out (for date range queries)
CREATE INDEX idx_booking_dates ON Booking(check_in_date, check_out_date);

-- 5. Index on created_at (for recent bookings)
CREATE INDEX idx_booking_created_at ON Booking(created_at);

-- 6. Composite index for user and status (common query pattern)
CREATE INDEX idx_booking_user_status ON Booking(user_id, status);

-- 7. Composite index for property availability checks
CREATE INDEX idx_booking_property_dates ON Booking(property_id, check_in_date, check_out_date, status);

-- =============================================================================
-- REVIEW TABLE INDEXES (Common additional table)
-- =============================================================================

-- Drop existing indexes
DROP INDEX IF EXISTS idx_review_property_id ON Review;
DROP INDEX IF EXISTS idx_review_user_id ON Review;
DROP INDEX IF EXISTS idx_review_rating ON Review;
DROP INDEX IF EXISTS idx_review_created_at ON Review;

-- 1. Index on property_id (for property reviews)
CREATE INDEX idx_review_property_id ON Review(property_id);

-- 2. Index on user_id (for user's reviews)
CREATE INDEX idx_review_user_id ON Review(user_id);

-- 3. Index on rating (for filtering by rating)
CREATE INDEX idx_review_rating ON Review(rating);

-- 4. Index on created_at (for recent reviews)
CREATE INDEX idx_review_created_at ON Review(created_at);

-- 5. Composite index for property rating analysis
CREATE INDEX idx_review_property_rating ON Review(property_id, rating);

-- =============================================================================
-- Show all created indexes
-- =============================================================================

SELECT 
    TABLE_NAME,
    INDEX_NAME,
    COLUMN_NAME,
    INDEX_TYPE
FROM information_schema.STATISTICS 
WHERE TABLE_SCHEMA = 'alx_airbnb'
ORDER BY TABLE_NAME, INDEX_NAME;
