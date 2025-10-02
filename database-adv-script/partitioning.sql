-- partitioning.sql
-- AirBnB Database Table Partitioning Script
-- This script implements table partitioning for better performance with large datasets

-- =============================================
-- 1. ANALYZE CURRENT TABLE SIZES AND GROWTH
-- =============================================

-- Check current table sizes and row counts
SELECT 
    tablename,
    pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename)) as total_size,
    pg_size_pretty(pg_relation_size(schemaname||'.'||tablename)) as table_size,
    (SELECT count(*) FROM bookings) as booking_count,
    (SELECT count(*) FROM reviews) as review_count,
    (SELECT count(*) FROM payments) as payment_count
FROM pg_tables 
WHERE schemaname = 'public' 
AND tablename IN ('bookings', 'reviews', 'payments', 'messages');

-- =============================================
-- 2. CREATE PARTITIONED TABLE STRUCTURES
-- =============================================

-- Enable partitioning if needed
CREATE EXTENSION IF NOT EXISTS btree_gist;

-- 2.1 Create partitioned bookings table by date range (quarterly)
CREATE TABLE bookings_partitioned (
    booking_id UUID NOT NULL,
    property_id UUID NOT NULL,
    user_id UUID NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    total_price DECIMAL(10,2) NOT NULL,
    status booking_status NOT NULL DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) PARTITION BY RANGE (start_date);

-- Create quarterly partitions for bookings (2023-2024)
CREATE TABLE bookings_q1_2023 PARTITION OF bookings_partitioned
    FOR VALUES FROM ('2023-01-01') TO ('2023-04-01');

CREATE TABLE bookings_q2_2023 PARTITION OF bookings_partitioned
    FOR VALUES FROM ('2023-04-01') TO ('2023-07-01');

CREATE TABLE bookings_q3_2023 PARTITION OF bookings_partitioned
    FOR VALUES FROM ('2023-07-01') TO ('2023-10-01');

CREATE TABLE bookings_q4_2023 PARTITION OF bookings_partitioned
    FOR VALUES FROM ('2023-10-01') TO ('2024-01-01');

CREATE TABLE bookings_q1_2024 PARTITION OF bookings_partitioned
    FOR VALUES FROM ('2024-01-01') TO ('2024-04-01');

-- Default partition for future dates
CREATE TABLE bookings_future PARTITION OF bookings_partitioned
    FOR VALUES FROM ('2024-04-01') TO (MAXVALUE);

-- 2.2 Create partitioned reviews table by created_at (monthly)
CREATE TABLE reviews_partitioned (
    review_id UUID NOT NULL,
    property_id UUID NOT NULL,
    user_id UUID NOT NULL,
    rating INTEGER NOT NULL,
    comment TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT valid_rating CHECK (rating >= 1 AND rating <= 5)
) PARTITION BY RANGE (created_at);

-- Create monthly partitions for reviews (2023-2024)
CREATE TABLE reviews_2023_03 PARTITION OF reviews_partitioned
    FOR VALUES FROM ('2023-03-01') TO ('2023-04-01');

CREATE TABLE reviews_2023_04 PARTITION OF reviews_partitioned
    FOR VALUES FROM ('2023-04-01') TO ('2023-05-01');

CREATE TABLE reviews_2023_05 PARTITION OF reviews_partitioned
    FOR VALUES FROM ('2023-05-01') TO ('2023-06-01');

CREATE TABLE reviews_2023_06 PARTITION OF reviews_partitioned
    FOR VALUES FROM ('2023-06-01') TO ('2023-07-01');

-- Default partition for future reviews
CREATE TABLE reviews_future PARTITION OF reviews_partitioned
    FOR VALUES FROM ('2023-07-01') TO (MAXVALUE);

-- 2.3 Create partitioned payments table by payment_date (monthly)
CREATE TABLE payments_partitioned (
    payment_id UUID NOT NULL,
    booking_id UUID NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    payment_method payment_method NOT NULL
) PARTITION BY RANGE (payment_date);

-- Create monthly partitions for payments
CREATE TABLE payments_2023_03 PARTITION OF payments_partitioned
    FOR VALUES FROM ('2023-03-01') TO ('2023-04-01');

CREATE TABLE payments_2023_04 PARTITION OF payments_partitioned
    FOR VALUES FROM ('2023-04-01') TO ('2023-05-01');

CREATE TABLE payments_2023_05 PARTITION OF payments_partitioned
    FOR VALUES FROM ('2023-05-01') TO ('2023-06-01');

CREATE TABLE payments_future PARTITION OF payments_partitioned
    FOR VALUES FROM ('2023-06-01') TO (MAXVALUE);

-- =============================================
-- 3. CREATE INDEXES ON PARTITIONED TABLES
-- =============================================

-- Indexes for partitioned bookings
CREATE INDEX CONCURRENTLY idx_bookings_part_user_id ON bookings_partitioned(user_id);
CREATE INDEX CONCURRENTLY idx_bookings_part_property_id ON bookings_partitioned(property_id);
CREATE INDEX CONCURRENTLY idx_bookings_part_dates ON bookings_partitioned(start_date, end_date);
CREATE INDEX CONCURRENTLY idx_bookings_part_status ON bookings_partitioned(status);
CREATE INDEX CONCURRENTLY idx_bookings_part_created_at ON bookings_partitioned(created_at);

-- Indexes for partitioned reviews
CREATE INDEX CONCURRENTLY idx_reviews_part_property_id ON reviews_partitioned(property_id);
CREATE INDEX CONCURRENTLY idx_reviews_part_user_id ON reviews_partitioned(user_id);
CREATE INDEX CONCURRENTLY idx_reviews_part_rating ON reviews_partitioned(rating);
CREATE INDEX CONCURRENTLY idx_reviews_part_created_at ON reviews_partitioned(created_at);

-- Indexes for partitioned payments
CREATE INDEX CONCURRENTLY idx_payments_part_booking_id ON payments_partitioned(booking_id);
CREATE INDEX CONCURRENTLY idx_payments_part_date ON payments_partitioned(payment_date);
CREATE INDEX CONCURRENTLY idx_payments_part_method ON payments_partitioned(payment_method);

-- =============================================
-- 4. MIGRATE DATA FROM ORIGINAL TABLES
-- =============================================

-- Migrate bookings data (in batches for large tables)
INSERT INTO bookings_partitioned 
SELECT * FROM bookings 
WHERE start_date >= '2023-01-01';

-- Migrate reviews data
INSERT INTO reviews_partitioned 
SELECT * FROM reviews 
WHERE created_at >= '2023-03-01';

-- Migrate payments data
INSERT INTO payments_partitioned 
SELECT * FROM payments 
WHERE payment_date >= '2023-03-01';

-- =============================================
-- 5. UPDATE FOREIGN KEY RELATIONSHIPS
-- =============================================

-- Note: In production, you would need to:
-- 1. Drop foreign key constraints temporarily
-- 2. Rename tables (original → _old, partitioned → original)
-- 3. Recreate foreign key constraints
-- 4. Update application connections

-- =============================================
-- 6. PERFORMANCE TESTING QUERIES
-- =============================================

-- Test query on partitioned bookings
EXPLAIN ANALYZE
SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    b.total_price,
    u.first_name,
    u.last_name,
    p.name as property_name
FROM bookings_partitioned b
JOIN users u ON b.user_id = u.user_id
JOIN properties p ON b.property_id = p.property_id
WHERE b.start_date BETWEEN '2023-03-01' AND '2023-06-30'
AND b.status = 'confirmed'
ORDER BY b.start_date;

-- Test query on partitioned reviews
EXPLAIN ANALYZE
SELECT 
    p.name as property_name,
    AVG(r.rating) as avg_rating,
    COUNT(r.review_id) as review_count
FROM reviews_partitioned r
JOIN properties p ON r.property_id = p.property_id
WHERE r.created_at BETWEEN '2023-03-01' AND '2023-05-31'
AND r.rating >= 4
GROUP BY p.property_id, p.name
ORDER BY avg_rating DESC;

-- Test query on partitioned payments
EXPLAIN ANALYZE
SELECT 
    p.payment_method,
    COUNT(p.payment_id) as payment_count,
    SUM(p.amount) as total_amount
FROM payments_partitioned p
WHERE p.payment_date BETWEEN '2023-03-01' AND '2023-05-31'
GROUP BY p.payment_method
ORDER BY total_amount DESC;

-- =============================================
-- 7. PARTITION MAINTENANCE FUNCTIONS
-- =============================================

-- Function to create new monthly partitions automatically
CREATE OR REPLACE FUNCTION create_monthly_partition(
    parent_table TEXT,
    partition_date DATE
) RETURNS VOID AS $$
DECLARE
    partition_name TEXT;
    start_date DATE;
    end_date DATE;
BEGIN
    start_date := date_trunc('month', partition_date);
    end_date := start_date + INTERVAL '1 month';
    partition_name := parent_table || '_' || to_char(start_date, 'YYYY_MM');
    
    EXECUTE format(
        'CREATE TABLE %I PARTITION OF %I FOR VALUES FROM (%L) TO (%L)',
        partition_name, parent_table, start_date, end_date
    );
    
    RAISE NOTICE 'Created partition: %', partition_name;
END;
$$ LANGUAGE plpgsql;

-- Function to drop old partitions (archive/delete)
CREATE OR REPLACE FUNCTION drop_old_partitions(
    parent_table TEXT,
    older_than_months INTEGER DEFAULT 12
) RETURNS VOID AS $$
DECLARE
    partition_record RECORD;
BEGIN
    FOR partition_record IN 
        SELECT partitiontablename
        FROM pg_partitions 
        WHERE tablename = parent_table 
        AND partitionrank IS NOT NULL
    LOOP
        -- Extract date from partition name and check if older than threshold
        -- Implementation depends on your partition naming convention
        CONTINUE;
    END LOOP;
END;
$$ LANGUAGE plpgsql;

-- =============================================
-- 8. MONITORING QUERIES
-- =============================================

-- Check partition sizes and usage
SELECT 
    schemaname,
    tablename,
    partitionscheme,
    partitionrange,
    partitionrank,
    partitiontablename
FROM pg_partitions 
WHERE schemaname = 'public'
ORDER BY tablename, partitionrank;

-- Monitor partition pruning effectiveness
EXPLAIN ANALYZE
SELECT count(*) 
FROM bookings_partitioned 
WHERE start_date BETWEEN '2023-04-01' AND '2023-04-30';

-- Check if queries are hitting the right partitions
SELECT 
    schemaname,
    relname,
    seq_scan,
    seq_tup_read,
    idx_scan,
    idx_tup_fetch
FROM pg_stat_user_tables 
WHERE relname LIKE '%partition%';
