# spec/controllers/api/v1/restaurants_controller_spec.rb

require 'rails_helper'

RSpec.describe Api::V1::RestaurantsController, type: :controller do
  let!(:restaurant) { create(:restaurant) }
  let(:restaurant_id) { restaurant.id }

  describe 'GET #index' do
    before { get :index }

    it 'returns a success status' do
      expect(response).to have_http_status(:success)
    end

    it 'returns all restaurants' do
      expect(JSON.parse(response.body).map { |r| r['id'] }).to include(restaurant.id)
    end
  end

  describe 'GET #show' do
    context 'with a restaurant that exists' do
      before { get :show, params: { id: restaurant_id } }

      it 'returns a success response' do
        expect(response).to have_http_status(:success)
      end

      it 'returns the expected restaurant attributes' do
        expect(JSON.parse(response.body).except('created_at', 'updated_at', 'menus')).to eq(restaurant.as_json.except('created_at', 'updated_at'))
      end
    end

    context 'with a restaurant that does not exist' do
      before { get :show, params: { id: 100 } }

      it 'returns status not_found' do
        expect(response).to have_http_status(:not_found)
      end

      it 'returns error message' do
        expect(JSON.parse(response.body)).to eq({ 'error' => 'Restaurant not found' })
      end
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      let(:valid_attributes) { { name: 'New Restaurant' } }

      subject { post :create, params: { restaurant: valid_attributes } }

      it 'returns status created' do
        subject
        expect(response).to have_http_status(:created)
      end

      it 'creates a new restaurant' do
        expect { subject }.to change(Restaurant, :count).by(1)
      end
    end

    context 'with invalid attributes' do
      subject { post :create, params: { restaurant: { name: nil } } }

      it 'does not add a new restaurant' do
        expect { subject }.not_to change(Restaurant, :count)
      end

      it 'returns unprocessable entity status' do
        subject
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns error messages' do
        subject
        expect(JSON.parse(response.body)).to include("name" => ["can't be blank"])
      end
    end
  end

  describe 'PATCH #update' do
    context 'with valid attributes' do
      subject { patch :update, params: { id: restaurant_id, restaurant: { name: 'Updated Restaurant' } } }

      it 'returns success status' do
        subject
        expect(response).to have_http_status(:success)
      end

      it 'updates the restaurant' do
        subject
        expect(restaurant.reload.name).to eq('Updated Restaurant')
      end
    end

    context 'with invalid attributes' do
      subject { patch :update, params: { id: restaurant_id, restaurant: { name: nil } } }

      it 'returns unprocessable entity status' do
        subject
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'does not update the restaurant' do
        expect { subject }.not_to change { restaurant.reload.name }
      end
    end

    context 'with a restaurant that does not exist' do
      subject { patch :update, params: { id: 100, restaurant: { name: 'Another Restaurant' } } }

      it 'returns status not_found' do
        subject
        expect(response).to have_http_status(:not_found)
      end

      it 'returns error message' do
        subject
        expect(JSON.parse(response.body)).to eq({ 'error' => 'Restaurant not found' })
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'with a restaurant that exists' do
      subject { delete :destroy, params: { id: restaurant_id } }

      it 'deletes the restaurant' do
        expect { subject }.to change(Restaurant, :count).by(-1)
      end

      it 'returns no content status' do
        subject
        expect(response).to have_http_status(:no_content)
      end
    end

    context 'with a restaurant that does not exist' do
      subject { delete :destroy, params: { id: 100 } }

      it 'returns status not_found' do
        subject
        expect(response).to have_http_status(:not_found)
      end

      it 'returns error message' do
        subject
        expect(JSON.parse(response.body)).to eq({ 'error' => 'Restaurant not found' })
      end
    end
  end
end