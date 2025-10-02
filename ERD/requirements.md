Entities and Attributes
User Entity

    user_id: Primary Key (UUID, Indexed)

    first_name: VARCHAR, NOT NULL

    last_name: VARCHAR, NOT NULL

    email: VARCHAR, UNIQUE, NOT NULL

    password_hash: VARCHAR, NOT NULL

    phone_number: VARCHAR, NULL

    role: ENUM (guest, host, admin), NOT NULL

    created_at: TIMESTAMP, DEFAULT CURRENT_TIMESTAMP

Property Entity

    property_id: Primary Key (UUID, Indexed)

    host_id: Foreign Key (references User.user_id)

    name: VARCHAR, NOT NULL

    description: TEXT, NOT NULL

    location: VARCHAR, NOT NULL

    pricepernight: DECIMAL, NOT NULL

    created_at: TIMESTAMP, DEFAULT CURRENT_TIMESTAMP

    updated_at: TIMESTAMP, ON UPDATE CURRENT_TIMESTAMP

Booking Entity

    booking_id: Primary Key (UUID, Indexed)

    property_id: Foreign Key (references Property.property_id)

    user_id: Foreign Key (references User.user_id)

    start_date: DATE, NOT NULL

    end_date: DATE, NOT NULL

    total_price: DECIMAL, NOT NULL

    status: ENUM (pending, confirmed, canceled), NOT NULL

    created_at: TIMESTAMP, DEFAULT CURRENT_TIMESTAMP

Payment Entity

    payment_id: Primary Key (UUID, Indexed)

    booking_id: Foreign Key (references Booking.booking_id)

    amount: DECIMAL, NOT NULL

    payment_date: TIMESTAMP, DEFAULT CURRENT_TIMESTAMP

    payment_method: ENUM (credit_card, paypal, stripe), NOT NULL

Review Entity

    review_id: Primary Key (UUID, Indexed)

    property_id: Foreign Key (references Property.property_id)

    user_id: Foreign Key (references User.user_id)

    rating: INTEGER, CHECK: rating >= 1 AND rating <= 5, NOT NULL

    comment: TEXT, NOT NULL

    created_at: TIMESTAMP, DEFAULT CURRENT_TIMESTAMP

Message Entity

    message_id: Primary Key (UUID, Indexed)

    sender_id: Foreign Key (references User.user_id)

    recipient_id: Foreign Key (references User.user_id)

    message_body: TEXT, NOT NULL

    sent_at: TIMESTAMP, DEFAULT CURRENT_TIMESTAMP

Relationships
Primary Relationships

    User → Property: One-to-Many

        A user (host) can have multiple properties

        A property belongs to one user (host)

    User → Booking: One-to-Many

        A user (guest) can have multiple bookings

        A booking belongs to one user (guest)

    Property → Booking: One-to-Many

        A property can have multiple bookings

        A booking is for one property

    Booking → Payment: One-to-Many

        A booking can have multiple payments

        A payment belongs to one booking

    User → Review: One-to-Many

        A user can write multiple reviews

        A review is written by one user

    Property → Review: One-to-Many

        A property can have multiple reviews

        A review is for one property

    User → Message: Two One-to-Many relationships

        A user can send multiple messages (as sender)

        A user can receive multiple messages (as recipient)
