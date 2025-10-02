Usage Instructions

    Save the script as sample_data.sql in your project directory

    Run the script after creating your database schema:

bash

# For PostgreSQL
psql -d your_database_name -f sample_data.sql

# For MySQL
mysql -u your_username -p your_database_name < sample_data.sql

Key Features of the Sample Data

    Realistic Data: Includes realistic names, locations, prices, and descriptions

    Complete Relationships: All foreign key relationships are properly maintained

    Varied Scenarios: Includes confirmed, pending, and canceled bookings

    Realistic Timelines: Booking dates and creation timestamps follow logical sequences

    Diverse Content: Various property types, locations, and price ranges

    User Interactions: Realistic conversations and review content

    Financial Integrity: Payment amounts match booking totals, including refunds

Data Verification

The script includes commented verification queries that you can run to ensure all data was populated correctly and check record counts across all tables.

This sample data provides a solid foundation for testing your AirBnB application and demonstrates real-world usage patterns.
