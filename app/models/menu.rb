# frozen_string_literal: true

class Menu < ApplicationRecord
  # Associations
  belongs_to :restaurant
  has_many :menu_items, dependent: :destroy

  # Nested attributes
  accepts_nested_attributes_for :menu_items, allow_destroy: true, reject_if: :all_blank

  # Validations
  validates :name, presence: true

  # Aliases
  alias_attribute :items, :menu_items
end
