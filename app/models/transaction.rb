class Transaction < ApplicationRecord
  validates :amount, presence: true, format: { with: /\A\d+(?:\.\d{0,2})?\z/ }, numericality: {greater_than_or_equal_to: 0}
  validates :source_id, presence: true, presence: true
  validates :destiny_id, presence: true, presence: true
end
