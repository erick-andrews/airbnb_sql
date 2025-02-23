BEGIN TRANSACTION;

-- CTE from staging
WITH new_data AS (
	SELECT
		listing_id,
		date_of_scraping,
		accuracy_score,
		checkin_score,
		communication_score
	FROM listings.airbnb_staging
)
-- Mark old records as invalid
UPDATE listings.review_scores_dim d
SET valid_to = CURRENT_TIMESTAMP,
	is_current = FALSE
FROM new_data s
WHERE d.listing_id = s.listing_id
AND d.date_of_scraping = s.date_of_scraping
AND d.is_current = TRUE
AND (
	d.communication_score <> s.communication_score
	OR d.accuracy_score <> s.accuracy_score
	OR d.checkin_score <> s.checkin_score
);
-- Same CTE as above
WITH new_data AS (
	SELECT
		listing_id,
		date_of_scraping,
		accuracy_score,
		checkin_score,
		communication_score
	FROM listings.airbnb_staging
)
-- Insert where invalid
INSERT INTO listings.review_scores_dim (
	listing_id,
	date_of_scraping,
	accuracy_score,
	checkin_score,
	communication_score,
	valid_from,
	valid_to,
	is_current
)
SELECT 
	s.listing_id,
	s.date_of_scraping,
	s.accuracy_score,
	s.checkin_score,
	s.communication_score,
	CURRENT_TIMESTAMP,
	NULL,
	TRUE
FROM new_data s
LEFT JOIN listings.review_scores_dim d
	ON s.listing_id = d.listing_id
	AND s.date_of_scraping = d.date_of_scraping
	AND d.is_current = TRUE
WHERE d.listing_id IS NULL 
	OR (
	d.communication_score <> s.communication_score
	OR d.accuracy_score <> s.accuracy_score
	OR d.checkin_score <> s.checkin_score
	);

COMMIT TRANSACTION;