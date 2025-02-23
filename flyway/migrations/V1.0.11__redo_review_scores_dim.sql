-- Additional Dimension Table for Review Scores
DROP TABLE IF EXISTS review_scores_dim CASCADE;
CREATE TABLE review_scores_dim (
    listing_id             BIGINT PRIMARY KEY,
    date_of_scraping       DATE,
    accuracy_score         DECIMAL(5, 2),
    checkin_score          DECIMAL(5, 2),
    communication_score    DECIMAL(5, 2),
    date_added             TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);