# spec/models/menu_item_spec.rb

require 'rails_helper'

RSpec.describe MenuItem, type: :model do
  let(:restaurant) { create(:restaurant) }
  let(:menu) { create(:menu, restaurant: restaurant) }
  let(:menu_item) { create(:menu_item, menu: menu) }

  describe 'associations' do
    it { is_expected.to belong_to(:menu) }
  end

  describe 'delegations' do
    it { should delegate_method(:restaurant_id).to(:menu) }
    it { should delegate_method(:restaurant).to(:menu) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:price_cents) }
    it { is_expected.to validate_length_of(:description).is_at_most(150).allow_blank }

    describe '#unique_name_within_restaurant' do
      context 'when name is unique' do
        it 'allow to create menu item' do
          not_duplicated_item = build(:menu_item, menu: menu, name: 'Another name')
          expect(not_duplicated_item).to be_valid
        end
      end

      context 'when name is not unique' do
        it 'does not allow to create menu item' do
          duplicate_item = build(:menu_item, menu: menu, name: menu_item.name)
          expect(duplicate_item).not_to be_valid
          expect(duplicate_item.errors[:name]).to include("is already in use for this restaurant")
        end
      end

      context 'when name is not unique but it is from different restaurant' do
        it 'allow to create menu item' do
          other_restaurant = create(:restaurant)
          other_menu = create(:menu, restaurant: other_restaurant)
          duplicate_item = build(:menu_item, menu: other_menu, name: menu_item.name)
          expect(duplicate_item).to be_valid
        end
      end
    end
  end
end
