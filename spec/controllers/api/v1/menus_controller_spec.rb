# spec/controllers/api/v1/menus_controller_spec.rb

require 'rails_helper'

RSpec.describe Api::V1::MenusController, type: :controller do
  let!(:menu) { create(:menu) }
  let!(:menu_item) { create(:menu_item, menu: menu) }

  describe 'GET #index' do
    before { get :index }

    it 'returns a successful status' do
      expect(response).to have_http_status(:success)
    end

    it 'returns the menu attributes' do
      expect(JSON.parse(response.body).first.except('menu_items')).to eq(menu.as_json)
    end

    it 'returns the related menu items' do
      expect(JSON.parse(response.body).first['menu_items'].first.except('price')).to eq(menu_item.as_json.except('menu_id', 'price_currency'))
    end
  end

  describe 'GET #show' do
    context 'with a menu that exists' do
      before { get :show, params: { id: menu.id } }

      it 'returns a successful status' do
        expect(response).to have_http_status(:success)
      end

      it 'returns the menu attributes' do
        expect(JSON.parse(response.body).except('menu_items')).to eq(menu.as_json)
      end

      it 'returns the related menu items' do
        expect(JSON.parse(response.body)['menu_items'].first.except('price')).to eq(menu_item.as_json.except('menu_id', 'price_currency'))
      end
    end

    context 'with a menu that does not exist' do
      before { get :show, params: { id: 100 } }

      it 'returns a successful status' do
        expect(response).to have_http_status(:not_found)
      end

      it 'returns a error message' do
        expect(JSON.parse(response.body)).to eq({ 'error' => 'Menu not found' })
      end
    end
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      let(:valid_params) do
        {
          menu: {
            name: "Christmas's Menu",
            menu_items_attributes: [
              { name: 'Ceaser Salad', price_cents: 900, quantity: '400g', description: 'Lorem Ipsum' }
            ]
          }
        }
      end

      subject { post :create, params: valid_params }

      it 'creates a new menu' do
        expect { subject }.to change(Menu, :count).by(1)
      end

      it 'returns created status' do
        subject
        expect(response).to have_http_status(:created)
      end
    end

    context 'with invalid parameters' do
      let(:invalid_params) { { menu: { name: nil } } }

      subject { post :create, params: invalid_params }

      it 'does not create a new menu' do
        expect { subject }.not_to change(Menu, :count)
      end

      it 'returns unprocessable entity status' do
        subject
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'with invalid menu items parameters' do
      let(:invalid_params) do
        {
          menu: {
            menu_items_attributes: [
              { name: nil, price_cents: nil }
            ]
          }
        }
      end

      subject { post :create, params: invalid_params }

      it 'does not create a new menu' do
        expect { subject }.not_to change(MenuItem, :count)
      end

      it 'returns unprocessable entity status' do
        subject
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PATCH #update' do
    context 'with valid parameters' do
      let(:new_attributes) do
        {
          menu: {
            menu_items_attributes: [
              { id: menu_item.id, name: 'Updated Salad', price_cents: 1000 }
            ]
          }
        }
      end

      subject { patch :update, params: new_attributes.merge(id: menu.id) }

      it 'updates the requested menu' do
        expect { subject }.to change { menu.reload.menu_items.first.name }.to('Updated Salad')
      end

      it 'returns success status' do
        subject
        expect(response).to have_http_status(:success)
      end
    end

    context 'with invalid parameters' do
      let(:params) do
        {
          id: menu.id,
          menu: {
            menu_items_attributes: [
              { id: menu_item.id, name: nil }
            ]
          }
        }
      end

      subject { patch :update, params: params }

      it 'does not update the requested menu' do
        expect { subject }.not_to change { menu.reload.menu_items.first.name }
      end
    end

    context 'with a menu that does not exist' do
      let(:params) { { id: 100 } }

      subject { patch :update, params: params }

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

  describe 'DELETE #destroy' do
    context 'with a menu that exists' do
      subject { delete :destroy, params: { id: menu.id } }

      it 'deletes the requested menu' do
        expect { subject }.to change(Menu, :count).by(-1)
      end

      it 'returns no content status' do
        subject
        expect(response).to have_http_status(:no_content)
      end
    end

    context 'with a menu that does not exist' do
      subject { delete :destroy, params: { id: 100 } }

      it 'deletes the requested menu' do
        expect { subject }.not_to change(Menu, :count)
      end

      it 'returns not found status' do
        subject
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
