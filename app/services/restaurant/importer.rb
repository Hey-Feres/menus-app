# frozen_string_literal: true

class Restaurant::Importer
  attr_reader :result, :json_data

  def initialize(file)
    file = File.read(file)
    @json_data = JSON.parse(file)
    @result = {}
  end

  def call
    json_data['restaurants'].each do |restaurant_data|
      process_restaurants(restaurant_data)

      result[@restaurant_name]['menus'] = {}
      restaurant_data['menus']&.each do |menu_data|
        process_menus(menu_data)
      end
    end

    result
  end

  private

  def process_restaurants(data)
    @restaurant_name = data['name']
    @restaurant = Restaurant.find_or_initialize_by(name: @restaurant_name)

    result[@restaurant_name] = {}
    restaurant_result = build_restaurant_result
    result[@restaurant_name][:restaurant] = restaurant_result
  end

  def process_menus(data)
    menu_name = data['name']
    @menu = @restaurant.menus.find_or_initialize_by(name: data['name'])

    result[@restaurant_name]['menus'][menu_name] = {}
    menu_result = build_menu_result
    result[@restaurant_name]['menus'][menu_name] = menu_result

    result[@restaurant_name]['menus'][menu_name]['menu_items'] = []
    menu_items_data = data['menu_items'] || data['dishes']
    menu_items_data&.each do |menu_item_data|
      process_menu_item(menu_item_data)
    end
  end

  def process_menu_item(data)
    item = @menu.menu_items.find_or_initialize_by(name: data['name'])
    old_price = item.price
    item.assign_attributes(price_cents: data['price'] * 100)

    item_result = build_item_result(item, old_price)
    result[@restaurant_name]['menus'][@menu.name]['menu_items'] << item_result
  end

  def build_restaurant_result
    if @restaurant.persisted?
      { result: 'Restaurant already exists' }
    elsif @restaurant.save
      { result: 'Restaurant created' }
    else
      { result: 'Restaurant could not be created', errors: @restaurant.errors.full_messages }
    end
  end

  def build_menu_result
    if @menu.persisted?
      { menu: { result: 'Menu already exists' } }
    elsif @menu.save
      { menu: { result: 'Menu created' } }
    else
      { menu: { result: 'Menu could not be created', errors: @menu.errors.full_messages } }
    end
  end

  def build_item_result(item, old_price)
    if item.persisted?
      res = { result: 'Menu Item already exists' }
      res[:info] = "Price was updated from #{old_price} to #{item.price}" if old_price != item.price
      res
    elsif item.save
      { result: 'Menu Item created' }
    else
      { result: 'Menu could not be created', errors: item.errors.full_messages }
    end
  end
end
