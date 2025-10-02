arkdown

# AirBnB Database Project

This project contains the database schema and Entity-Relationship Diagram (ERD) for an AirBnB-style accommodation booking platform.

## Project Structure

alx-airbnb-database/
│
├── ERD/
│ ├── requirements.md
│ └── airbnb_erd.png (or .xml for Draw.io)
│
├── schema.sql
├── README.md
└── sample_data.sql (optional)
text


## Database Schema Overview

The database consists of 6 main entities that model the core functionality of a property rental platform:

### Entities

1. **Users** - Platform users (guests, hosts, and admins)
2. **Properties** - Rental properties listed by hosts
3. **Bookings** - Reservation records linking users to properties
4. **Payments** - Payment transactions for bookings
5. **Reviews** - User reviews and ratings for properties
6. **Messages** - Communication between users

### Key Features

- **UUID Primary Keys**: All tables use UUIDs for secure, globally unique identifiers
- **Data Integrity**: Constraints and foreign keys ensure relational integrity
- **Performance**: Indexes on frequently queried columns
- **Flexibility**: ENUM types for standardized status values
- **Audit Trail**: Timestamp tracking for all major events

## Entity Relationships

Users (1) → (M) Properties
Users (1) → (M) Bookings
Properties (1) → (M) Bookings
Bookings (1) → (M) Payments
Users (1) → (M) Reviews
Properties (1) → (M) Reviews
Users (1) → (M) Messages (as sender)
Users (1) → (M) Messages (as recipient)
text


## Installation and Setup

### Prerequisites
- PostgreSQL 12+ or MySQL 8+
- Basic SQL knowledge

### PostgreSQL Setup
```sql
-- Create database
CREATE DATABASE airbnb;

-- Connect to database
\c airbnb;

-- Run schema
\i schema.sql

MySQL Setup
sql

-- Create database
CREATE DATABASE airbnb;

-- Use database
USE airbnb;

-- Run schema (remove UUID functions and adjust syntax as needed)
SOURCE schema.sql;

Table Specifications
Users Table

Stores user accounts with role-based access control.

    Roles: guest, host, admin

    Security: Password hashing required

    Uniqueness: Email must be unique

Properties Table

Manages property listings with host relationships.

    Relations: Each property belongs to one host

    Pricing: Decimal precision for accurate pricing

    Timestamps: Tracks creation and updates

Bookings Table

Handles reservation lifecycle and scheduling.

    Status Flow: pending → confirmed → canceled

    Date Validation: Ensures logical booking periods

    Pricing: Calculates total based on duration

Payments Table

Records financial transactions for bookings.

    Payment Methods: credit_card, paypal, stripe

    Audit: Timestamped payment records

    Integrity: Linked to specific bookings

Reviews Table

Manages user feedback and ratings system.

    Rating System: 1-5 star scale with constraints

    Relations: Links users to specific properties

    Content: Supports detailed comments

Messages Table

Facilitates user-to-user communication.

    Bidirectional: Supports sender/recipient relationships

    Timestamps: Chronological message tracking

    Flexibility: Text-based messaging

Constraints and Validation

    Foreign Keys: All relationships maintain referential integrity

    Data Types: Appropriate types for each attribute

    Constraints: NOT NULL, UNIQUE, CHECK constraints

    Cascading: DELETE CASCADE for dependent records

Performance Optimization

    Indexes: Strategic indexing on foreign keys and search columns

    UUIDs: Non-sequential identifiers for security

    Normalization: 3rd normal form compliance

Usage Examples
Create a Host User
sql

INSERT INTO users (first_name, last_name, email, password_hash, role)
VALUES ('John', 'Doe', 'john@example.com', 'hashed_password', 'host');

List a Property
sql

INSERT INTO properties (host_id, name, description, location, pricepernight)
VALUES (
    'user-uuid-here',
    'Cozy Apartment',
    'Beautiful downtown apartment',
    'New York, NY',
    120.00
);

Contributing

    Fork the repository

    Create a feature branch

    Commit your changes

    Submit a pull request

License

This project is part of the ALX Software Engineering program
