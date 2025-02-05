-- CTE from staging
WITH new_data AS (
	SELECT
		listing_id,
		property_type,
		beds_number,
		bedrooms_number,
		bathrooms_number,
		max_allowed_guests,
		date_added
	FROM airbnb_staging
)
-- Mark old records as invalid
UPDATE airbnb_staging d
SET valid_to = CURRENT_TIMESTAMP,
	is_current = FALSE
FROM new_data s
WHERE d.listing_id = s.listing_id
AND d.is_current = TRUE
AND (
	d.property_type <> n.property_type,
	d.beds_number <> n.beds_number,
	d.bedrooms_number <> n.bedrooms_number,
	d.bathrooms_number <> n.bathrooms_number,
	d.max_allowed_guests <> n.max_allowed_guests
);
-- Insert where invalid
INSERT INTO listings_dim (
	listing_id,
	property_type,
	beds_number,
	bedrooms_number,
	bathrooms_number,
	max_allowed_guests,
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
LEFT JOIN listings_dim d
	ON s.listing_id = d.listing_id
	AND d.is_current = TRUE
WHERE d.listing_id IS NULL 
	OR (
	d.property_type <> n.property_type,
	d.beds_number <> n.beds_number,
	d.bedrooms_number <> n.bedrooms_number,
	d.bathrooms_number <> n.bathrooms_number,
	d.max_allowed_guests <> n.max_allowed_guests
	);