-- Indexes for Users table
CREATE INDEX idx_users_email ON users(email);

-- Indexes for Bookings table
CREATE INDEX idx_bookings_user_id ON bookings(user_id);
CREATE INDEX idx_bookings_property_id ON bookings(property_id);
CREATE INDEX idx_bookings_created_at ON bookings(created_at);

-- Indexes for Properties table
CREATE INDEX idx_properties_name ON properties(name);
CREATE INDEX idx_properties_location ON properties(location);

-- Example of a composite index (if queries often filter by property + date)
CREATE INDEX idx_bookings_property_date ON bookings(property_id, created_at);
