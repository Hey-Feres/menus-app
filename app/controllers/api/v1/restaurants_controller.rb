# frozen_string_literal: true

class Api::V1::RestaurantsController < ApplicationController
  before_action :set_restaurant, only: %i[show update destroy]

  # GET /restaurants
  def index
    @restaurants = Restaurant.all

    render json: @restaurants
  end

  # GET /restaurants/:id
  def show
    render json: @restaurant
  end

  # POST /restaurants
  def create
    @restaurant = Restaurant.new(restaurant_params)

    if @restaurant.save
      render json: @restaurant, status: :created
    else
      render json: @restaurant.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /restaurants/:id
  def update
    if @restaurant.update(restaurant_params)
      render json: @restaurant
    else
      render json: @restaurant.errors, status: :unprocessable_entity
    end
  end

  # DELETE /restaurants/:id
  def destroy
    @restaurant.destroy
  end

  def import
    result = Restaurant::Importer.new(params[:file]).call
    render json: result
  end

  def import_options
    render json: {
      title: 'Import Restaurant Data Endpoint',
      allowed_methods: ['POST', 'OPTIONS'],
      description: "This endpoint allows you to import restaurants data from a JSON file.\n\nThe expected structure is { restaurants: [{ name: 'Restaurant Name', menus: [{ name: 'Menu Name', menu_items: [{ name: 'Item Name', price: 10 }] }]}] }"
    }, status: :ok
  end

  private

  def set_restaurant
    @restaurant = Restaurant.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Restaurant not found' }, status: :not_found
  end

  def restaurant_params
    params.require(:restaurant).permit(:name)
  end
end
