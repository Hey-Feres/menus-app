# spec/controllers/api/v1/menu_items_controller_spec.rb

require 'rails_helper'

RSpec.describe Api::V1::MenuItemsController, type: :controller do
  let!(:menu) { create(:menu) }
  let!(:menu_item) { create(:menu_item, menu: menu, price_cents: 1_000) }

  describe 'GET #index' do
    context 'with a menu item that exists' do
      before { get :index, params: { menu_id: menu.id } }

      it 'returns a success status' do
        expect(response).to have_http_status(:success)
      end

      it 'returns the expected object structure' do
        expect(JSON.parse(response.body).first.except('menu', 'price')).to eq(menu_item.as_json.except('menu_id', 'price_currency'))
      end

      it 'returns price formatted' do
        expect(JSON.parse(response.body).first['price']).to eq('$10.00')
      end

      it 'returns the related menu' do
        expect(JSON.parse(response.body).first['menu']).to eq(menu.as_json)
      end
    end

    context 'with a menu that does not exists' do
      before { get :index, params: { menu_id: 100 } }

      it 'returns status not_found' do
        expect(response).to have_http_status(:not_found)
      end

      it 'returns error message' do
        expect(JSON.parse(response.body)).to eq({ 'error' => 'Menu not found' })
      end
    end
  end

  describe 'GET #show' do
    context 'with a menu item that exists' do
      before { get :show, params: { menu_id: menu.id, id: menu_item.id } }

      it 'returns a success response' do
        expect(response).to have_http_status(:success)
      end

      it 'returns the expected object structure' do
        expect(JSON.parse(response.body).except('menu', 'price')).to eq(menu_item.as_json.except('menu_id', 'price_currency'))
      end

      it 'returns price formatted' do
        expect(JSON.parse(response.body)['price']).to eq('$10.00')
      end

      it 'returns the related menu' do
        expect(JSON.parse(response.body)['menu']).to eq(menu.as_json)
      end
    end

    context 'with a menu item that does not exists' do
      before { get :show, params: { menu_id: menu.id, id: 100 } }

      it 'returns status not_found' do
        expect(response).to have_http_status(:not_found)
      end

      it 'returns error message' do
        expect(JSON.parse(response.body)).to eq({ 'error' => 'Menu item not found' })
      end
    end

    context 'with a menu that does not exists' do
      before { get :show, params: { menu_id: 100, id: menu_item.id } }

      it 'returns status not_found' do
        expect(response).to have_http_status(:not_found)
      end

      it 'returns error message' do
        expect(JSON.parse(response.body)).to eq({ 'error' => 'Menu not found' })
      end
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      let(:valid_attributes) { { name: 'New Item', price_cents: 1000, quantity: '500g', description: 'Delicious' } }

      subject { post :create, params: { menu_id: menu.id, menu_item: valid_attributes } }

      it 'returns status created' do
        subject
        expect(response).to have_http_status(:created)
      end

      it 'creates a new menu item' do
        expect { subject }.to change(MenuItem, :count).by(1)
      end
    end

    context 'with invalid attributes' do
      subject { post :create, params: { menu_id: menu.id, menu_item: { name: '', price_cents: nil } } }

      it 'does not add a new Menu Item' do
        expect { subject }.not_to change(MenuItem, :count)
      end

      it 'returns unprocessable entity when invalid' do
        subject
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PATCH #update' do
    context 'with valid attributes' do
      subject { patch :update, params: { menu_id: menu.id, id: menu_item.id, menu_item: { name: 'Updated Item' } } }

      it 'returns success status' do
        subject
        expect(response).to have_http_status(:success)
      end

      it 'updates a menu item' do
        expect { subject }.to change { MenuItem.find(menu_item.id).name }.to('Updated Item')
      end
    end

    context 'with invalid attributes' do
      subject { patch :update, params: { menu_id: menu.id, id: menu_item.id, menu_item: { price_cents: nil } } }

      it 'returns unprocessable entity when invalid' do
        subject
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'does not update a menu item' do
        expect { subject }.not_to change { MenuItem.find(menu_item.id).name }
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'with a object that exists' do
      subject { delete :destroy, params: { menu_id: menu.id, id: menu_item.id }}

      it 'deletes a menu item' do
        expect { subject }.to change(MenuItem, :count).by(-1)
      end

      it 'returns head no content' do
        subject
        expect(response).to have_http_status(:no_content)
      end
    end

    context 'with a menu item that does not exists' do
      subject { delete :destroy, params: { menu_id: menu.id, id: 100 }}

      it 'returns status not_found' do
        subject
        expect(response).to have_http_status(:not_found)
      end

      it 'returns error message' do
        subject
        expect(JSON.parse(response.body)).to eq({ 'error' => 'Menu item not found' })
      end
    end

    context 'with a menu that does not exists' do
      subject { delete :destroy, params: { menu_id: 100, id: menu_item.id }}

      it 'returns status not_found' do
        subject
        expect(response).to have_http_status(:not_found)
      end

      it 'returns error message' do
        subject
        expect(JSON.parse(response.body)).to eq({ 'error' => 'Menu not found' })
      end
    end
  end
end
