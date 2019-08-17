# Carbon Footprint Calculator 
This app calculates the carbon footprint for a typical New Zealand household.

August 2019 : Working on providing users with there ghg emissions from using electricity!

## Technologies
CSS framework : Bulma

Front end : Rails v5.2, Fusion Charts

Back end : Rails v5.2

Testing : Rspec, FactoryBot

Linting : Rubocop

Charts : Chartjs

## Configuration

TBA

## Database creation and initialization

To set up dev database from scratch
`bin/rails db:migrate`- set up database
`bin/rails power:import_ea_exist_generation` - generation_stations table
`bin/rails power:import_half_hourly_emissions_table_csv` - half_hourly_emissions table
`bin/rails power:import_ea_profile`- profiles table
`bin/rails power:import_trader_data` - traders table

The processed_emi_files and temp_half_hourly_emissions tables are really just used in production.

## How to run the test suite

In the command line: `bundle exec rspec`

## Services (job queues, cache servers, search engines, etc.)

TBA

## Deployment instructions

Deployed to Heroku: See https://ghgemissions.herokuapp.com/
