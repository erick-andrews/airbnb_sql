BEGIN TRANSACTION;
-- CTE from staging
WITH row_data AS (
	SELECT
		city,
		neighbourhood,
		coordinates,
		ROW_NUMBER() OVER (
			PARTITION BY coordinates
			ORDER BY coordinates
		) AS rn
	FROM listings.airbnb_staging
),
new_data AS (
	SELECT
		city,
		neighbourhood,
		coordinates
	FROM row_data
	WHERE rn=1
)
-- Mark old records as invalid
UPDATE listings.location_dim d
SET valid_to = CURRENT_TIMESTAMP,
	is_current = FALSE
FROM new_data s
WHERE d.coordinates = s.coordinates
AND d.is_current = TRUE
AND (
	d.city <> s.city
	OR d.neighbourhood <> s.neighbourhood
	OR d.coordinates <> s.coordinates
);
-- Same CTE as above
WITH row_data AS (
	SELECT
		city,
		neighbourhood,
		coordinates,
		ROW_NUMBER() OVER (
			PARTITION BY coordinates
			ORDER BY coordinates
		) AS rn
	FROM listings.airbnb_staging
),
new_data AS (
	SELECT
		city,
		neighbourhood,
		coordinates
	FROM row_data
	WHERE rn=1
)
-- Insert where invalid
INSERT INTO listings.location_dim (
	city,
	neighbourhood,
	coordinates,
	valid_from,
	valid_to,
	is_current
)
SELECT 
	s.city,
	s.neighbourhood,
	s.coordinates,
	CURRENT_TIMESTAMP,
	NULL,
	TRUE
FROM new_data s
LEFT JOIN listings.location_dim d
	ON s.coordinates = d.coordinates
	AND d.is_current = TRUE
WHERE d.coordinates IS NULL 
	OR (
	d.city <> s.city
	OR d.neighbourhood <> s.neighbourhood
	OR d.coordinates <> s.coordinates
	);

COMMIT TRANSACTION;