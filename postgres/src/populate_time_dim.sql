BEGIN TRANSACTION;
-- CTE from staging
WITH row_data AS (
	SELECT
		date_of_scraping,
		season
		ROW_NUMBER() OVER (
			PARTITION BY date_of_scraping
			ORDER BY date_of_scraping
		) AS rn
	FROM listings.airbnb_staging
),
new_data AS (
	SELECT
		date_of_scraping,
		season
	FROM row_data
	WHERE rn=1
)
-- Mark old records as invalid
UPDATE listings.time_dim d
SET valid_to = CURRENT_TIMESTAMP,
	is_current = FALSE
FROM new_data s
WHERE d.date_of_scraping = s.date_of_scraping
AND d.is_current = TRUE
AND (
	AND	d.date_of_scraping <> s.date_of_scraping
	OR d.season <> s.season
);
-- Same CTE as above
WITH row_data AS (
	SELECT
		date_of_scraping,
		season,
		ROW_NUMBER() OVER (
			PARTITION BY date_of_scraping
			ORDER BY date_of_scraping
		) AS rn
	FROM listings.airbnb_staging
),
new_data AS (
	SELECT
		date_of_scraping,
		season
	FROM row_data
	WHERE rn=1
)
-- Insert where invalid
INSERT INTO listings.time_dim (
	date_of_scraping,
	season,
	valid_from,
	valid_to,
	is_current
)
SELECT 
	s.date_of_scraping,
	s.season,
	CURRENT_TIMESTAMP,
	NULL,
	TRUE
FROM new_data s
LEFT JOIN listings.time_dim d
	ON s.date_of_scraping = d.date_of_scraping
	AND d.is_current = TRUE
WHERE d.date_of_scraping IS NULL 
	OR (
	d.date_of_scraping <> s.date_of_scraping
	OR d.season <> s.season
	);

COMMIT TRANSACTION;