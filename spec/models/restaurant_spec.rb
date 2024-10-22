# spec/models/restaurant_spec.rb

require 'rails_helper'

RSpec.describe Restaurant, type: :model do
  it { should validate_presence_of(:name) }

  it { should have_many(:menus).dependent(:destroy) }
end