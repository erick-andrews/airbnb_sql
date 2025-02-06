-- Handling SCD Type 1: Overwrites in the DB
INSERT INTO listings_dim (
	listing_id,
	property_type,
	beds_number,
	bedrooms_number,
	bathrooms_number,
	max_allowed_guests,
	date_added
	)
SELECT 
	listing_id,
	property_type,
	beds_number,
	bedrooms_number,
	bathrooms_number,
	max_allowed_guests,
	date_added
FROM airbnb_staging;
ON CONFLICT (listing_id) DO UPDATE
SET
	property_type = EXCLUDED.property_type
	beds_number = EXCLUDED.beds_number,
	bedrooms_number = EXCLUDED.bedrooms_number,
	bathrooms_number = EXCLUDED.bathrooms_number,
	max_allowed_guests = EXCLUDED.max_allowed_guests,
	date_added = CURRENT_TIMESTAMP;