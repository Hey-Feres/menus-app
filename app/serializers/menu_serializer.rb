# frozen_string_literal: true

class MenuSerializer < ActiveModel::Serializer
  attributes :id, :name, :created_at, :updated_at

  has_many :menu_items
end
