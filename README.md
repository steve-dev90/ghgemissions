# Carbon Footprint Calculator
This app calculates the carbon footprint for a typical New Zealand household.

August 2019 : Working on providing users with there ghg emissions from using electricity!

## Technologies
CSS framework : Bulma

Front end : Rails v5.2

Back end : Rails v5.2

Testing : Rspec, FactoryBot

Linting : Rubocop

Charts : Chartjs

## Configuration

Emails are sent using Sendgrid:

- Developer email password and username are set using rails application credentials (https://www.engineyard.com/blog/rails-encrypted-credentials-on-rails-5.2)
- Production email password and username are set using Heroku ENV variables

## Database creation and initialization

To set up dev database from scratch:

- `bin/rails db:migrate`- set up database
- `bin/rails power:import_ea_exist_generation` - generation_stations table
- `bin/rails power:import_half_hourly_emissions_table_csv` - half_hourly_emissions table
- `bin/rails power:import_ea_profile`- profiles table
- `bin/rails power:import_trader_data` - traders table

The processed_emi_files and temp_half_hourly_emissions tables are really just used in production.

## How to run the test suite

For all tests: In the command line: `bundle exec rspec`

For a single test (example): In the command line: `bundle exec rspec ./spec/services/power/profile_data_spec.rb`

## Services (job queues, cache servers, search engines, etc.)

In production `bin/rails power:emi_cleared_data_daily_import` is run daily using Heroku Scheduler. This task imports and processes daily cleared offer data from the Electricity Authority's EMI Microsoft Azure Storage.

References:

- https://devcenter.heroku.com/articles/scheduler
- https://www.emi.ea.govt.nz/Forum/thread/new-access-arrangements-to-emi-datasets-retirement-of-anonymous-ftp/

## Deployment instructions

Deployed to Heroku: See https://ghgemissions.herokuapp.com/
