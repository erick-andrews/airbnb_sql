-- Populate listings_performance_fact
-- Assume only insert per best practice for fact table in OLAP
INSERT INTO listings.listings_performance_fact (
	-- dim ids
    listings_dim_id, time_dim_id, location_dim_id, review_scores_dim_id,
    -- fact information
    price, total_reviews, rating_score, value_for_money_score, cleanliness_score, location_score, reviews_per_month,
    -- denormalized host data
    host_since, host_is_superhost, host_number_of_listings
)
SELECT 
	-- dim ids
    l.listings_dim_id, t.time_dim_id, loc.location_dim_id, r.review_scores_dim_id,
    -- fact information
    s.price, s.total_reviews, s.rating_score, s.value_for_money_score, s.cleanliness_score, s.location_score, s.reviews_per_month,
    -- denorm host data
    s.host_since, s.host_is_superhost, s.host_number_of_listings
FROM listings.airbnb_staging s
-- left join on uniques from listings, location, time, and review_scores
LEFT JOIN listings.listings_dim l ON s.listing_id = l.listing_id
LEFT JOIN listings.location_dim loc ON s.coordinates = loc.coordinates
LEFT JOIN listings.time_dim t ON s.date_of_scraping = t.date_of_scraping AND s.season = t.season
LEFT JOIN listings.review_scores_dim r ON s.listing_id = r.listing_id AND s.date_of_scraping = r.date_of_scraping;