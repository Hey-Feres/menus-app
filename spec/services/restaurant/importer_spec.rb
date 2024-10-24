# spec/serivces/restaurant/importer_spec.rb

require 'rails_helper'

RSpec.describe Restaurant::Importer do
  describe 'call' do
    let!(:file_path) { 'spec/support/files/restaurant_data.json' }

    context 'when restaurants does not exist' do
      subject { Restaurant::Importer.new(file_path).call }

      it 'creates the restaurants' do
        expect { subject }.to change { Restaurant.count }.by(2)
      end

      it 'creates the restaurants with the expected names' do
        subject
        expect(Restaurant.last(2).pluck(:name)).to eq(["Poppo's Cafe", 'Casa del Poppo'])
      end
    end

    context 'when the restaurants already exists' do
      subject { Restaurant::Importer.new(file_path).call }

      before do
        create(:restaurant, name: 'Poppo\'s Cafe')
        create(:restaurant, name: 'Casa del Poppo')
      end

      it 'does not create a restaurant' do
        expect { subject }.not_to change { Restaurant.count }
      end
    end

    context 'when menus does not exist' do
      subject { Restaurant::Importer.new(file_path).call }

      it 'creates the menus' do
        expect { subject }.to change { Menu.count }.by(4)
      end

      it 'creates the menus with the expected names' do
        subject
        expect(Menu.last(4).pluck(:name)).to eq(%w[lunch dinner lunch dinner])
      end

      it 'creates the menus associated with the correct restaurants' do
        subject
        expect(Restaurant.last.menus.pluck(:name)).to eq(%w[lunch dinner])
        expect(Restaurant.first.menus.pluck(:name)).to eq(%w[lunch dinner])
      end
    end

    context 'when menu items does not exist' do
      it 'creates the menu items', skip: 'Not implemented yet' do
        pending('Not implemented yet')
      end

      it 'creates the menu items with the expected attributes', skip: 'Not implemented yet' do
        pending('Not implemented yet')
      end

      it 'creates the menu items associated with the correct menus', skip: 'Not implemented yet' do
        pending('Not implemented yet')
      end
    end

    context 'when menu items already exists' do
      it 'does not create a menu item', skip: 'Not implemented yet' do
      end
    end
  end
end
