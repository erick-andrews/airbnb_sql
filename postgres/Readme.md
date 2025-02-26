# Postgres Scripts to Populate Database

This repository contains postgres scripts (DML) to populate the airbnb database. It also contains a shell script for reproducible namespace creation and bitnami helm chart deployment.

The build folder contains the bitnami helm deployment information.

src contains a shell script with a copy command for copying cleaned data into the staging table of the postgres dev database. It also contains DML for populating dimension tables and fact tables, as well as relevant SQL for exploring the data and answering questions about it. The idea behind this is treating postgres as an ROLAP imitation of Redshift.