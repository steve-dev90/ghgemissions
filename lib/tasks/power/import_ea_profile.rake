require 'roo'

namespace :power do
  desc 'Import EA rps profile for GXP CPK0111 stored in spreadsheet'
  task import_ea_profile: :environment do
    profile = Power::ProfileData.new('./lib/assets/CPK0111 RPS.xlsx')
    profile.call
  end
end