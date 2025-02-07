BEGIN TRANSACTION;
-- CTE from staging
WITH row_data AS (
	SELECT
		listing_id,
		property_type,
		beds_number,
		bedrooms_number,
		bathrooms_number,
		max_allowed_guests,
		ROW_NUMBER() OVER (
			PARTITION BY listing_id
			ORDER BY listing_id
		) AS rn
	FROM listings.airbnb_staging
),
new_data AS (
	SELECT
		listing_id,
		property_type,
		beds_number,
		bedrooms_number,
		bathrooms_number,
		max_allowed_guests
	FROM row_data
	WHERE rn=1
)
-- Mark old records as invalid
UPDATE listings.listings_dim d
SET valid_to = CURRENT_TIMESTAMP,
	is_current = FALSE
FROM new_data s
WHERE d.listing_id = s.listing_id
AND d.is_current = TRUE
AND (
	d.property_type <> s.property_type
	OR d.beds_number <> s.beds_number
	OR d.bedrooms_number <> s.bedrooms_number
	OR d.bathrooms_number <> s.bathrooms_number
	OR d.max_allowed_guests <> s.max_allowed_guests
);
-- Same CTE as above
WITH row_data AS (
	SELECT
		listing_id,
		property_type,
		beds_number,
		bedrooms_number,
		bathrooms_number,
		max_allowed_guests,
		ROW_NUMBER() OVER (
			PARTITION BY listing_id
			ORDER BY listing_id
		) AS rn
	FROM listings.airbnb_staging
),
new_data AS (
	SELECT
		listing_id,
		property_type,
		beds_number,
		bedrooms_number,
		bathrooms_number,
		max_allowed_guests
	FROM row_data
	WHERE rn=1
)
-- Insert where invalid
INSERT INTO listings.listings_dim (
	listing_id,
	property_type,
	beds_number,
	bedrooms_number,
	bathrooms_number,
	max_allowed_guests,
	valid_from,
	valid_to,
	is_current
)
SELECT 
	s.listing_id,
	s.property_type,
	s.beds_number,
	s.bedrooms_number,
	s.bathrooms_number,
	s.max_allowed_guests,
	CURRENT_TIMESTAMP,
	NULL,
	TRUE
FROM new_data s
LEFT JOIN listings.listings_dim d
	ON s.listing_id = d.listing_id
	AND d.is_current = TRUE
WHERE d.listing_id IS NULL 
	OR (
	d.property_type <> s.property_type
	OR d.beds_number <> s.beds_number
	OR d.bedrooms_number <> s.bedrooms_number
	OR d.bathrooms_number <> s.bathrooms_number
	OR d.max_allowed_guests <> s.max_allowed_guests
	);

COMMIT TRANSACTION;