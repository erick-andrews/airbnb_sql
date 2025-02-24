-- Practice Joins for information from Dim tables
-- Examining prices, reviews, and bed/bath averages per type of property.
WITH listings AS (
	SELECT ld.listing_id, lpf.time_dim_id, lpf.price, lpf.total_reviews, ld.property_type, ld.beds_number, ld.bedrooms_number, ld.bathrooms_number FROM listings_performance_fact lpf 
	LEFT JOIN listings_dim ld
	ON  lpf.listings_dim_id = ld.listings_dim_id
)
--listing_id, td.date_of_scraping, td.season
SELECT property_type, AVG(price) AS avg_price, 
					  AVG(total_reviews) AS avg_reviews, 
					  AVG(beds_number) AS avg_bed_number, 
					  AVG(bedrooms_number) AS avg_bedrooms,
					  AVG(bathrooms_number) AS avg_bathrooms FROM listings l
GROUP BY property_type;

-- How many listings are managed by superhosts total?
SELECT host_is_superhost, SUM(host_number_of_listings) FROM listings_performance_fact lpf
GROUP BY host_is_superhost;

-- What percent of listings among these cities is managed by superhosts?
WITH tot_listing AS (
SELECT host_is_superhost, SUM(host_number_of_listings) AS total_listings FROM listings_performance_fact lpf
GROUP BY host_is_superhost
) SELECT (SUM(CASE WHEN host_is_superhost=TRUE THEN total_listings ELSE 0 END)/SUM(total_listings)*100) AS percentage_superhost_run FROM tot_listing;

-- What is the average price of an Airbnb listing by property type in each city? 
WITH citypt AS (
SELECT ld2.listing_id, lpf.price, lpf.total_reviews, ld.city, ld.neighbourhood, ld2.beds_number, ld2.bedrooms_number, ld2.bathrooms_number, td.date_of_scraping FROM listings_performance_fact lpf 
LEFT JOIN location_dim ld
ON  lpf.location_dim_id = ld.location_dim_id 
LEFT JOIN listings_dim ld2
ON lpf.listings_dim_id = ld2.listings_dim_id
LEFT JOIN time_dim td 
ON lpf.time_dim_id = td.time_dim_id
)
SELECT city, AVG(price) AS city_avg_price FROM citypt
GROUP BY city;

-- Which neighborhoods have the highest/lowest average listing prices? (Tableau Follow Up)