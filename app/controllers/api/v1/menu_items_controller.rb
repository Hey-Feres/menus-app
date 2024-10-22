# frozen_string_literal: true

class Api::V1::MenuItemsController < ApplicationController
  include RestaurantChildConcern

  before_action :set_menu
  before_action :set_menu_item, only: %i[show update destroy]

  # GET restaurant/:restaurant_id/menus/:menu_id/menu_items
  def index
    @menu_items = @menu.items

    render json: @menu_items
  end

  # GET restaurant/:restaurant_id/menus/:menu_id/menu_items/:id
  def show
    render json: @menu_item
  end

  # POST restaurant/:restaurant_id/menus/:menu_id/menu_items
  def create
    @menu_item = @menu.items.new(menu_item_params)

    if @menu_item.save
      render json: @menu_item, status: :created
    else
      render json: @menu_item.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT restaurant/:restaurant_id/menus/:menu_id/menu_items/:id
  def update
    if @menu_item.update(menu_item_params)
      render json: @menu_item
    else
      render json: @menu_item.errors, status: :unprocessable_entity
    end
  end

  # DELETE restaurant/:restaurant_id/menus/:menu_id/menu_items/:id
  def destroy
    @menu_item.destroy
    head :no_content
  end

  private

  def set_menu_item
    @menu_item = @menu.items.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Menu item not found' }, status: :not_found
  end

  def set_menu
    @menu = @restaurant.menus.find(params[:menu_id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Menu not found' }, status: :not_found
  end

  def menu_item_params
    params.require(:menu_item).permit(:name, :price_cents, :quantity, :description)
  end
end
