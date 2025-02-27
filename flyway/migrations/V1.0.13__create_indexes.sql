-- Creating indexes for performance of lpf central table
CREATE INDEX IF NOT EXISTS lpf_time ON listings_performance_fact (time_dim_id);
CREATE INDEX IF NOT EXISTS lpf_locations ON listings_performance_fact (location_dim_id);
CREATE INDEX IF NOT EXISTS lpf_listings ON listings_performance_fact (listings_dim_id);
CREATE INDEX IF NOT EXISTS lpf_rs ON listings_performance_fact (review_scores_dim_id);