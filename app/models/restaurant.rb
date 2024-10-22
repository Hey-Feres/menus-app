# frozen_string_literal: true

class Restaurant < ApplicationRecord
  # Validations
  validates :name, presence: true

  # Associations
  has_many :menus, dependent: :destroy
end
