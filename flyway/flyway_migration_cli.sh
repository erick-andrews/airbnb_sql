#!/bin/bash

# Prompt the user to enter the PostgreSQL password securely
read -s -p "Enter PostgreSQL password: " PG_PASSWORD
echo ""  # Move to a new line after input

# Run Flyway migration inside Docker
docker run --rm \
    -v /home/eandrews/projects/airbnb_sql/flyway/migrations:/flyway/sql \
    flyway/flyway \
    -url=jdbc:postgresql://172.17.0.1:5433/dev_airbnb \
    -schemas=listings \
    -user=eandrews \
    -password=$PG_PASSWORD \
    migrate

# Clear the password variable for security
unset PG_PASSWORD