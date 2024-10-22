# frozen_string_literal: true

class Api::V1::MenusController < ApplicationController
  include RestaurantChildConcern

  before_action :set_menu, only: %i[show update destroy]

  # GET restaurants/:restaurant_id/menus
  def index
    @menus = @restaurant.menus

    render json: @menus
  end

  # GET restaurants/:restaurant_id/menus/:id
  def show
    render json: @menu
  end

  # POST restaurants/:restaurant_id/menus
  def create
    @menu = @restaurant.menus.new(menu_params)

    if @menu.save
      render json: @menu, status: :created
    else
      render json: @menu.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT restaurants/:restaurant_id/menus/:id
  def update
    if @menu.update(menu_params)
      render json: @menu
    else
      render json: @menu.errors, status: :unprocessable_entity
    end
  end

  # DELETE restaurants/:restaurant_id/menus/:id
  def destroy
    @menu.destroy
    head :no_content
  end

  private

  def set_menu
    @menu = Menu.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Menu not found' }, status: :not_found
  end

  def menu_params
    params.require(:menu).permit(:name, menu_items_attributes: %i[id name price_cents quantity description _destroy])
  end
end
