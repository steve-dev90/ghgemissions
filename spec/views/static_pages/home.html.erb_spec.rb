require 'rails_helper'

RSpec.describe "static_pages/home.html.erb", type: :view do
  it 'successfully renders' do
    render

    rendered.should match("Carbon")
  end
end
