# frozen_string_literal: true

class MenuItem < ApplicationRecord
  # Associations
  belongs_to :menu

  # Validations
  validates :name, :price_cents, presence: true
  validates :description, length: { maximum: 150 }, allow_blank: true

  def price
    Money.new(price_cents)
  end
end
