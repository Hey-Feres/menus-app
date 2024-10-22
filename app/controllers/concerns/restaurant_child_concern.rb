# frozen_string_literal: true

module RestaurantChildConcern
  extend ActiveSupport::Concern

  included do
    before_action :set_restaurant
  end

  private

  def set_restaurant
    @restaurant = Restaurant.find(params[:restaurant_id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Restaurant not found' }, status: :not_found
  end
end