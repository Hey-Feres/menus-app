# frozen_string_literal: true

class MenuItem < ApplicationRecord
  # Associations
  belongs_to :menu

  # Validations
  validates :name, :price_cents, presence: true
  validates :description, length: { maximum: 150 }, allow_blank: true
  validate :unique_name_within_restaurant

  # Delegations
  delegate :restaurant, to: :menu
  delegate :restaurant_id, to: :menu

  def price
    Money.new(price_cents)
  end

  private

  def unique_name_within_restaurant
    return unless menu && menu.restaurant_id

    if MenuItem.joins(:menu)
               .where(menus: { restaurant_id: })
               .where(name: name)
               .where.not(id: id)
               .exists?

      errors.add(:name, 'is already in use for this restaurant')
    end
  end
end
