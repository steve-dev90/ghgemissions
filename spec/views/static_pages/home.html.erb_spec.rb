require 'rails_helper'

RSpec.describe "static_pages/home.html.erb", type: :view do
  it 'successfully renders' do
    render
    expect(rendered).to match /How much electricity did you consume today?/
  end
end
