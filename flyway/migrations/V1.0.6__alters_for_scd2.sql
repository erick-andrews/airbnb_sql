-- Removing constraints from tables
ALTER TABLE location_dim 
DROP CONSTRAINT IF EXISTS location_dim_pkey CASCADE;

ALTER TABLE listings_performance_fact 
DROP CONSTRAINT IF EXISTS fk_listing CASCADE,
DROP CONSTRAINT IF EXISTS fk_time CASCADE,
DROP CONSTRAINT IF EXISTS fk_host CASCADE,
DROP CONSTRAINT IF EXISTS fk_location CASCADE;

ALTER TABLE review_scores_dim
DROP CONSTRAINT IF EXISTS fk_review_listing CASCADE,
DROP CONSTRAINT IF EXISTS review_scores_dim_pkey CASCADE;

ALTER TABLE time_dim
DROP CONSTRAINT IF EXISTS time_dim_pkey CASCADE;

ALTER TABLE listings_dim
DROP CONSTRAINT IF EXISTS listings_dim_pkey CASCADE;

ALTER TABLE host_dim
DROP CONSTRAINT IF EXISTS host_dim_pkey CASCADE; 

-- Adding surrogate primary keys to tables and columns for SCD Type 2
ALTER TABLE listings_dim 
ADD COLUMN listings_dim_id INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
ADD COLUMN IF NOT EXISTS valid_from TIMESTAMP DEFAULT CURRENT_TIMESTAMP, 
ADD COLUMN IF NOT EXISTS valid_to TIMESTAMP, 
ADD COLUMN IF NOT EXISTS is_current BOOLEAN DEFAULT TRUE;

ALTER TABLE location_dim 
ADD COLUMN location_dim_id INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
ADD COLUMN IF NOT EXISTS valid_from TIMESTAMP DEFAULT CURRENT_TIMESTAMP, 
ADD COLUMN IF NOT EXISTS valid_to TIMESTAMP, 
ADD COLUMN IF NOT EXISTS is_current BOOLEAN DEFAULT TRUE;

ALTER TABLE listings_performance_fact 
ADD COLUMN listings_performance_fact_id INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
ADD COLUMN IF NOT EXISTS valid_from TIMESTAMP DEFAULT CURRENT_TIMESTAMP, 
ADD COLUMN IF NOT EXISTS valid_to TIMESTAMP, 
ADD COLUMN IF NOT EXISTS is_current BOOLEAN DEFAULT TRUE;

ALTER TABLE review_scores_dim
ADD COLUMN review_scores_dim_id INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
ADD COLUMN IF NOT EXISTS valid_from TIMESTAMP DEFAULT CURRENT_TIMESTAMP, 
ADD COLUMN IF NOT EXISTS valid_to TIMESTAMP, 
ADD COLUMN IF NOT EXISTS is_current BOOLEAN DEFAULT TRUE;

ALTER TABLE time_dim 
ADD COLUMN time_dim_id INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
ADD COLUMN IF NOT EXISTS valid_from TIMESTAMP DEFAULT CURRENT_TIMESTAMP, 
ADD COLUMN IF NOT EXISTS valid_to TIMESTAMP, 
ADD COLUMN IF NOT EXISTS is_current BOOLEAN DEFAULT TRUE;

ALTER TABLE host_dim 
ADD COLUMN host_dim_id INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
ADD COLUMN IF NOT EXISTS valid_from TIMESTAMP DEFAULT CURRENT_TIMESTAMP, 
ADD COLUMN IF NOT EXISTS valid_to TIMESTAMP, 
ADD COLUMN IF NOT EXISTS is_current BOOLEAN DEFAULT TRUE;