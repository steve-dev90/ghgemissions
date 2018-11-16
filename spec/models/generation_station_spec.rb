require 'rails_helper'

FactoryBot.define do
  factory :GenerationStation do
      station_name { 'Huntly' }
      poc { 'HLY2201' }
      fuel_name { 'Gas' }
      generation_type { 'Thermal' }
      primary_efficiency { 9000 }
      emissions_factor { 0.48 }
  end
end

RSpec.describe GenerationStation, type: :model do
  it "has a valid factory" do
    expect(FactoryBot.create(:GenerationStation)).to be_valid
  end

  it "invalidates records with no station name" do
    station = GenerationStation.new(station_name: 'Huntly', poc: 'HLY2201',
      fuel_name: 'Gas', generation_type: 'Thermal', primary_efficiency: 9000, emissions_factor: 0.48)
    # pp station.valid?
    # pp station.errors.messages

    expect(station.valid?).to eq(true)
  end
end

# RSpec.describe Post, :type => :model do
#   context "with 2 or more comments" do
#     it "orders them in reverse chronologically" do
#       post = Post.create!
#       comment1 = post.comments.create!(:body => "first comment")
#       comment2 = post.comments.create!(:body => "second comment")
#       expect(post.reload.comments).to eq([comment2, comment1])
#     end
#   end
# end