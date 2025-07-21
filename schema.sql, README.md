-- Sample Users
INSERT INTO User (user_id, first_name, last_name, email, password_hash, role)
VALUES
  (UUID(), 'Alice', 'Kimani', 'alice@example.com', 'hashed_pw_1', 'guest'),
  (UUID(), 'John', 'Owino', 'john@example.com', 'hashed_pw_2', 'host');

-- Sample Property
INSERT INTO Property (property_id, host_id, name, description, location, pricepernight)
VALUES
  (UUID(), 'johns-uuid', 'Seaside Villa', 'Beautiful view', 'Mombasa, Kenya', 120.00);
