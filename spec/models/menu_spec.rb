# spec/models/menu_spec.rb

require 'rails_helper'

RSpec.describe Menu, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:restaurant) }
    it { is_expected.to have_many(:menu_items).dependent(:destroy) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
  end

  describe 'nested attributes' do
    it { is_expected.to accept_nested_attributes_for(:menu_items).allow_destroy(true) }

    describe 'reject_if option' do
      it 'rejects menu items with all blank attributes' do
        restaurant = create(:restaurant)
        menu = Menu.new(restaurant:, name: 'Menu Name', menu_items_attributes: [{ name: '' }, { price_cents: nil }])
        expect(menu.valid?).to be_truthy
        expect(menu.menu_items.size).to eq(0)
      end

      it 'accepts valid menu items' do
        restaurant = create(:restaurant)
        menu = Menu.new(restaurant:, name: 'Menu Name', menu_items_attributes: [{ name: 'Valid Item', price_cents: 1000 }])
        expect(menu.valid?).to be_truthy
        expect(menu.menu_items.size).to eq(1)
      end
    end
  end

  describe 'aliases' do
    it 'aliases menu_items as items' do
      menu = Menu.new
      expect(menu).to respond_to(:items)
    end
  end
end
