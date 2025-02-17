BEGIN TRANSACTION;
-- CTE from staging
WITH row_data AS (
	SELECT
		date_of_scraping,
		season,
		host_since,
		ROW_NUMBER() OVER (
			PARTITION BY host_since
			ORDER BY host_since
		) AS rn
	FROM listings.airbnb_staging
),
new_data AS (
	SELECT
		date_of_scraping,
		season,
		host_since
	FROM row_data
	WHERE rn=1
)
-- Mark old records as invalid
UPDATE listings.location_dim d
SET valid_to = CURRENT_TIMESTAMP,
	is_current = FALSE
FROM new_data s
WHERE d.host_since = s.host_since
AND d.is_current = TRUE
AND (
	d.date_of_scraping <> s.date_of_scraping
	OR d.season <> s.season
	OR d.host_since <> s.host_since
);
-- Same CTE as above
WITH row_data AS (
	SELECT
		date_of_scraping,
		season,
		host_since,
		ROW_NUMBER() OVER (
			PARTITION BY host_since
			ORDER BY host_since
		) AS rn
	FROM listings.airbnb_staging
),
new_data AS (
	SELECT
		date_of_scraping,
		season,
		host_since
	FROM row_data
	WHERE rn=1
)
-- Insert where invalid
INSERT INTO listings.location_dim (
	date_of_scraping,
	season,
	host_since,
	valid_from,
	valid_to,
	is_current
)
SELECT 
	s.date_of_scraping,
	s.season,
	s.host_since,
	CURRENT_TIMESTAMP,
	NULL,
	TRUE
FROM new_data s
LEFT JOIN listings.location_dim d
	ON s.host_since = d.host_since
	AND d.is_current = TRUE
WHERE d.host_since IS NULL 
	OR (
	d.date_of_scraping <> s.date_of_scraping
	OR d.season <> s.season
	OR d.host_since <> s.host_since
	);

COMMIT TRANSACTION;