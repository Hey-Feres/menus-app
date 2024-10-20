# frozen_string_literal: true

class MenuItemSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :quantity, :price_cents, :price, :created_at, :updated_at

  belongs_to :menu

  def price
    object.price.format
  end
end
