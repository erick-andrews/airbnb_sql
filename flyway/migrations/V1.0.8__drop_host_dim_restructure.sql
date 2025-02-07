-- Drop host_dim table, unneeded.
DROP TABLE IF EXISTS host_dim CASCADE;

-- Remove column from listings_performance_fact: host_id
ALTER TABLE listings_performance_fact
DROP COLUMN IF EXISTS host_id;

-- Denormalize and add host information to central fact for data mart.
ALTER TABLE listings_performance_fact
ADD COLUMN IF NOT EXISTS host_since DATE,
ADD COLUMN IF NOT EXISTS host_is_superhost BOOLEAN,
ADD COLUMN IF NOT EXISTS host_number_of_listings DECIMAL(10, 2);