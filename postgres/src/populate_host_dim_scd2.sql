-- CTE from staging
WITH new_data AS (
	SELECT
		host_id,
		host_since,
		host_is_superhost,
		host_number_of_listings
	FROM listings.airbnb_staging
)
-- Mark old records as invalid
UPDATE listings.host_dim d
SET valid_to = CURRENT_TIMESTAMP,
	is_current = FALSE
FROM new_data s
WHERE d.host_id = s.host_id
AND d.is_current = TRUE
AND (
	d.host_since <> s.host_since
	OR d.host_is_superhost <> s.host_is_superhost
	OR d.host_number_of_listings <> s.host_number_of_listings
);
-- Same CTE as above
WITH new_data AS (
	SELECT
		host_id,
		host_since,
		host_is_superhost,
		host_number_of_listings
	FROM listings.airbnb_staging
)
-- Insert where invalid
INSERT INTO listings.host_dim (
	host_id,
	host_since,
	host_is_superhost,
	host_number_of_listings,
	valid_from,
	valid_to,
	is_current
)
SELECT 
	s.host_id,
	s.host_since,
	s.host_is_superhost,
	s.host_number_of_listings,
	CURRENT_TIMESTAMP,
	NULL,
	TRUE
FROM new_data s
LEFT JOIN listings.host_dim d
	ON s.host_id = d.host_id
	AND d.is_current = TRUE
WHERE d.host_id IS NULL 
	OR (
	d.host_since <> s.host_since
	OR d.host_is_superhost <> s.host_is_superhost
	OR d.host_number_of_listings <> s.host_number_of_listings
	);