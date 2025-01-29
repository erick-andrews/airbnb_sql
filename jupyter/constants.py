# column mapping for initial Italy airbnb dataset
column_mapping = {
    'Listings id': 'listing_id',
    'Last year reviews': 'last_year_reviews',
    'Host since': 'host_since',
    'Host is superhost': 'host_is_superhost',
    'Host number of listings': 'host_number_of_listings',
    'Neighbourhood': 'neighbourhood',
    'Beds number': 'beds_number',
    'Bedrooms number': 'bedrooms_number',
    'Property type': 'property_type',
    'Maximum allowed guests': 'max_allowed_guests',
    'Price': 'price',
    'Total reviews': 'total_reviews',
    'Rating score': 'rating_score',
    'Accuracy score': 'accuracy_score',
    'Cleanliness score': 'cleanliness_score',
    'Checkin score': 'checkin_score',
    'Communication score': 'communication_score',
    'Location score': 'location_score',
    'Value for money score': 'value_for_money_score',
    'Reviews per month': 'reviews_per_month',
    'City': 'city',
    'Season': 'season',
    'Bathrooms number': 'bathrooms_number',
    'Bathrooms type': 'bathrooms_type',
    'Coordinates': 'coordinates',
    'Date of scraping': 'date_of_scraping'
}
# Staging columns for Postgres Load
staging_columns = [
    'listing_id',
    'last_year_reviews',
    'host_since',
    'host_is_superhost',
    'host_number_of_listings',
    'neighbourhood',
    'beds_number',
    'bedrooms_number',
    'property_type',
    'max_allowed_guests',
    'price',
    'total_reviews',
    'rating_score',
    'accuracy_score',
    'cleanliness_score',
    'checkin_score',
    'communication_score',
    'location_score',
    'value_for_money_score',
    'reviews_per_month',
    'city',
    'season',
    'bathrooms_number',
    'bathrooms_type',
    'coordinates',
    'date_of_scraping'
]
