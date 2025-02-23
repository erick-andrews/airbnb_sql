-- Drop the table if it exists
DROP TABLE IF EXISTS listings.listings_performance_fact CASCADE;
CREATE TABLE listings.listings_performance_fact (
    listings_dim_id        INT,        -- Replaces listing_id
    time_dim_id            INT,        -- Replaces season, date_of_scraping
    location_dim_id        INT,        -- Replaces city, neighbourhood
    review_scores_dim_id   INT,        -- Replaces review scores
    price                  DECIMAL(10, 2),
    total_reviews          INT,
    rating_score           DECIMAL(5, 2),
    value_for_money_score  DECIMAL(5, 2),
    cleanliness_score      DECIMAL(5, 2),
    location_score         DECIMAL(5, 2),
    reviews_per_month      DECIMAL(5, 2),
    host_since             DATE,
    host_is_superhost      BOOLEAN,
    host_number_of_listings NUMERIC(10, 2),
    date_added             TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    valid_from             TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    valid_to               TIMESTAMP NULL,
    is_current             BOOLEAN DEFAULT TRUE,
    -- Composite Primary Key - Surrogate Primary not necessary in this context.
    -- This works on assumption that each listing_id + scrape date combination is unique
    PRIMARY KEY (listings_dim_id, time_dim_id)
);