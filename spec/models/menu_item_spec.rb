# spec/models/menu_item_spec.rb

require 'rails_helper'

RSpec.describe MenuItem, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:menu) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:price_cents) }
    it { is_expected.to validate_length_of(:description).is_at_most(150).allow_blank }
  end
end
